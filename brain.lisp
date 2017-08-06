(load "package.lisp")

(load "translate.lisp")
(load "commands.lisp")
(load "maki-uchi.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *keep-going* t)
(defvar *brain-output* t)
(defvar *brain-input* *query-io*)

(add-top-level-command "hello" (just-reply "hello"))
(add-top-level-command "goodbye" (just-reply "goodbye"))
(add-top-level-command "unintelligible" (just-reply "failed to parse"))

(defun brain-output (line)
  (format *brain-output* "~a~%" line))

(defun brain-input ()
  (read-line *brain-input*))

(defun brain-output* (line-or-lines)
  (if (listp line-or-lines)
      (mapcar 'output line-or-lines)
    (brain-output line-or-lines)))

(defun main-loop ()
  (loop while *keep-going*
	do (brain-output* (process (brain-input) *top-level-commands*))))
