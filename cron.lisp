(load "package.lisp")
(load "state.lisp")
(load "event.lisp")
(load "utils.lisp")

(in-package #:com.aragaer.pa-brain)

(defclass scheduled-reminder (thought)
  ((name :initform :cron)))

(defmethod react ((thought scheduled-reminder) event)
  (let ((intent (getf event :intent)))
    (if (and (not (getf event :modifiers))
	     (starts-with-p intent "cron"))
	(add-modifier event :scheduled
		      (string-trim " " (subseq intent (length "cron")))))))

(defmethod process ((thought scheduled-reminder) event)
  (aif (get-modifier event :scheduled)
      (setf (getf event :response)
	    (append (getf event :response) `(,it)))))

(conspack:defencoding scheduled-reminder
		      name)
