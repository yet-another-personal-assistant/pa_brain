(load "package.lisp")
(load "state.lisp")

(in-package #:com.aragaer.pa-brain)

(defparameter *greet-timeout* (* 20 60 60))

(defclass greeter (thought)
  ((last-seen :initform 0)))

(defmethod react ((thought greeter) event)
  (with-slots (last-seen) thought
    (cond ((< (+ last-seen *greet-timeout*) (get-universal-time)) (add-modifier event :hello))
	  ((string-equal (getf event :intent) "hello") (add-modifier event :seen-already)))
    (setq last-seen (get-universal-time))))

(defmethod process ((thought greeter) event)
  (cond ((get-modifier event :hello) (setf (getf event :response)
					   (push "hello" (getf event :response))))
	((get-modifier event :seen-already) (setf (getf event :response)
						  (push "seen already" (getf event :response))))))

