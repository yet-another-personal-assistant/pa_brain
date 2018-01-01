(load "package.lisp")
(load "utils.lisp")
(load "state.lisp")
(load "event.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *top-level-commands* ())

(defmacro add-command (subset command handler)
  `(setq ,subset (acons ,command ,handler ,subset)))

(defun process-command (command commands)
  (aif (assoc command commands :test 'starts-with-p)
       (funcall (cdr it) (string-trim " " (subseq command (length (car it)))))))

(defclass old-handler (thought)
  ((name :initform :old)))

(conspack:defencoding old-handler
		      name)

(defmethod react ((thought old-handler) event))

(defun known-hello-or-empty-p (event)
  (let ((intent (getf event :intent))
	(mods (getf event :modifiers)))
    (or (assoc-if-not #'(lambda (mod) (equalp mod :hello)) mods)
	(not intent) ; no intent means an internal event
	(string= "hello" intent)
	(string= "" intent))))

(defmethod process ((thought old-handler) event)
  (let ((intent (getf event :intent)))
    (unless (getf event :response)
      (aif (process-command intent *top-level-commands*)
	   (add-response event it)
	   (unless (known-hello-or-empty-p event)
	     (add-response event (format nil "unknown command \"~a\"" intent)))))))
