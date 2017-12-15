(load "package.lisp")
(load "event.lisp")
(load "state.lisp")
(load "utils.lisp")

(in-package #:com.aragaer.pa-brain)

(defclass dialog (thought)
  ((name :initarg :name)
   (triggers :initarg :triggers)))

(defmethod react ((thought dialog) event)
  (let ((intent (getf event :intent)))
    (aif (assoc intent (slot-value thought 'triggers) :test 'starts-with-p)
	 (funcall (cdr it) event (string-trim " " (subseq intent (length (car it))))))))
