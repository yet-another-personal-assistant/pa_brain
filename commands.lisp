(load "package.lisp")
(load "utils.lisp")
(load "state.lisp")

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
  (aif (assoc command commands :test 'starts-with-p)
       (funcall (cdr it) (string-trim " " (subseq command (length (car it)))))
       (unknown-command command)))
