(load "package.lisp")

(in-package #:com.aragaer.pa-brain)
(load "commands.lisp")

(defun maki-uchi-log (arg)
  (format nil "log ~a maki-uchi" arg))

(defun maki-uchi-status (arg)
  (format nil "maki-uchi status" arg))

(defun maki-uchi (arg)
  (process arg (list (cons "status" 'maki-uchi-status)
		     (cons "log" 'maki-uchi-log))))

(add-top-level-command "maki-uchi" 'maki-uchi)
