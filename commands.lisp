(load "package.lisp")
(load "utils.lisp")

(in-package #:com.aragaer.pa-brain)

(defmacro just-reply (reply)
  `#'(lambda (arg) (translate-pa2human ,reply)))

(defvar *top-level-commands* ())

(defmacro add-command (subset command handler)
  `(setq ,subset (acons ,command ,handler ,subset)))

(defun add-top-level-command (command handler)
  (add-command *top-level-commands* command handler))

(defun unknown-command (command)
  (when (> (length command) 0)
    (translate-pa2human (format nil "unknown command \"~a\"" command))))

(defun process (command commands)
  (let ((entry (assoc command commands :test 'starts-with-p)))
    (if entry
	(funcall (cdr entry) (string-trim " " (subseq command (length (car entry)))))
      (unknown-command command))))
