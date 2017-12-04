(load "package.lisp")
(load "utils.lisp")
(load "state.lisp")
(load "event.lisp")

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

(defun process-command (command commands)
  (aif (assoc command commands :test 'starts-with-p)
       (funcall (cdr it) (string-trim " " (subseq command (length (car it)))))
       (unknown-command command)))

(defclass old-handler (thought)
  ())

(defmethod react ((thought old-handler) event))

(defmethod process ((thought old-handler) event)
  (if (not (or (getf event :modifiers) (getf event :response)))
      (add-response event (process-command (getf event :intent) *top-level-commands*))))
