(load "package.lisp")
(load "state.lisp")

(in-package #:com.aragaer.pa-brain)

(defclass greeter (thought)
  ((seen :initform nil)))

(defmethod react ((thought greeter) event)
  (with-slots (seen) thought
    (cond ((not seen) (add-modifier event :hello))
	  ((string-equal (getf event :intent) "hello") (add-modifier event :seen-already)))
    (setq seen t)))

(defmethod process ((thought greeter) event)
  (cond ((get-modifier event :hello) (setf (getf event :response)
					   (push "hello" (getf event :response))))
	((get-modifier event :seen-already) (setf (getf event :response)
						  (push "seen already" (getf event :response))))))

