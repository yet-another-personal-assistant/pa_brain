(load "package.lisp")

(in-package #:com.aragaer.pa-brain)

(defmacro just-reply (reply)
  `#'(lambda (arg) (translate-pa2human ,reply)))

(defvar *top-level-commands* ())

(defmacro add-command (subset command handler)
  `(setq ,subset (cons (cons ,command ,handler) ,subset)))

(defun add-top-level-command (command handler)
  (add-command *top-level-commands* command handler))

(defun unknown-command (command)
  (if (> (length command) 0)
      (translate-pa2human (format nil "unknown command \"~a\"" command))))

(defun starts-with-p (string1 string2)
  (string= string1 string2 :end1 (min (length string1) (length string2))))

(defun process (command commands)
  (let ((entry (assoc command commands :test 'starts-with-p)))
    (if entry
	(funcall (cdr entry) (string-trim " " (subseq command (length (car entry)))))
      (unknown-command command))))
