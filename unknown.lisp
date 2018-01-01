(load "package.lisp")
(load "state.lisp")
(load "event.lisp")
(load "utils.lisp")

(in-package #:com.aragaer.pa-brain)

(defclass dont-understand (thought)
  ((name :initform :dont-understand)))

(defmethod react ((thought dont-understand) event)
  (if (starts-with-p (getf event :intent) "unintelligible")
      (let ((what (string-trim " " (subseq (getf event :intent) (length "unintelligible")))))
	(add-modifier event :dont-understand (or (string= "" what) what)))))

(defun known-hello-or-empty-p (event)
  (let ((intent (getf event :intent))
	(mods (getf event :modifiers)))
    (or (assoc-if-not #'(lambda (mod) (equalp mod :hello)) mods)
	(not intent) ; no intent means an internal event
	(string= "hello" intent)
	(string= "" intent))))

(defmethod process ((thought dont-understand) event)
  (cond ((get-modifier event :dont-understand)
	 (add-response event "failed to parse"))
	((not (known-hello-or-empty-p event))
	 (add-response event (format nil "unknown command \"~a\"" (getf event :intent))))))

(conspack:defencoding dont-understand
		      name)
