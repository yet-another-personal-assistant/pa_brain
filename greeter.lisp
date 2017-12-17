(load "package.lisp")
(load "state.lisp")
(load "event.lisp")

(in-package #:com.aragaer.pa-brain)

(defclass greeter (thought)
  ((name :initform :greeter)
   (said-hello :initform nil)))

(defmethod react ((thought greeter) event)
  (with-slots (said-hello) thought
    (cond ((not said-hello)
	   (add-modifier event :hello))
	  ((string-equal (getf event :event) "new day")
	   (setf said-hello nil))
	  ((string-equal (getf event :intent) "hello")
	   (add-modifier event :seen-already)))))

(defmethod process ((thought greeter) event)
  (with-slots (said-hello) thought
    (cond ((and (getf event :text) (get-modifier event :hello))
	   (setf said-hello t)
	   (setf (getf event :response) (push "hello" (getf event :response))))
	  ((get-modifier event :seen-already)
	   (setf (getf event :response) (push "seen already" (getf event :response)))))))

(conspack:defencoding greeter
		      name said-hello)
