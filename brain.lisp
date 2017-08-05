(load "package.lisp")

(load "translate.lisp")

(in-package #:com.aragaer.pa-brain)
(load "commands.lisp")

(defvar *keep-going* t)

(defun maki-uchi-log (arg)
  (format nil "log ~a maki-uchi" arg))

(defun maki-uchi-status (arg)
  (format nil "maki-uchi status" arg))

(defun maki-uchi (arg)
  (process arg (list (cons "status" 'maki-uchi-status)
		     (cons "log" 'maki-uchi-log))))

(add-top-level-command "hello" (just-reply "hello"))
(add-top-level-command "goodbye" (just-reply "goodbye"))
(add-top-level-command "unintelligible" (just-reply "failed to parse"))

(add-top-level-command "maki-uchi" 'maki-uchi)

(defun main-loop ()
  (loop while *keep-going*
	do (let ((message (process (read-line *query-io*) *top-level-commands*)))
	     (if message
		 (format t "~a~%" message)))))
