(load "package.lisp")
(load "utils.lisp")
(load "state.lisp")

(in-package #:com.aragaer.pa-brain)

(defmacro just-reply (reply)
  `#'(lambda (arg) ,reply))

(defvar *top-level-commands* ())

(defmacro add-command (subset command handler)
  `(setq ,subset (acons ,command ,handler ,subset)))

(defun add-top-level-command (command handler)
  (add-command *top-level-commands* command handler))

(defun unknown-command (command)
  (when (> (length command) 0)
    (format nil "unknown command \"~a\"" command)))

(defun process (command commands)
  (aif (assoc command commands :test 'starts-with-p)
       (funcall (cdr it) (string-trim " " (subseq command (length (car it)))))
       (unknown-command command)))

(defclass old-handler (handler)
  ())

(defmethod handles-p ((handler old-handler) trigger)
  (assoc trigger *top-level-commands* :test 'starts-with-p))

(defmethod handle ((handler old-handler) message)
  (process message *top-level-commands*))
