(load "package.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *thoughts* ())

(defclass thought ()
  ())

(defgeneric react (thought event))
(defgeneric process (thought event))

(defun try-handle (event)
  (loop for thought in *thoughts*
	do (react thought event))
  (loop for thought in *thoughts*
	do (process thought event)))

(defun add-thought (thought)
  (push thought *thoughts*))
