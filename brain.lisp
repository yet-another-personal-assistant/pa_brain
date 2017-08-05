(load "package.lisp")

(load "translate.lisp")
(load "commands.lisp")
(load "maki-uchi.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *keep-going* t)

(add-top-level-command "hello" (just-reply "hello"))
(add-top-level-command "goodbye" (just-reply "goodbye"))
(add-top-level-command "unintelligible" (just-reply "failed to parse"))

(defun main-loop ()
  (loop while *keep-going*
	do (let ((message (process (read-line *query-io*) *top-level-commands*)))
	     (if message
		 (format t "~a~%" message)))))
