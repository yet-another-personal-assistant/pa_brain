(load "package.lisp")
(load "translate.lisp")

(in-package :com.aragaer.pa-brain)

(defun get-reply (message)
  (translate-pa2human (react (translate-human2pa message))))

(defun react (intent)
  (cond ((string= intent "hello")
	 "hello")
	(t
	 "dont-understand")))
