(load "package.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *handlers* ())

(defclass handler ()
  ())

(defgeneric handles-p (handler trigger))
(defgeneric handle (handler message))
(defgeneric reset (handler))

(defun try-handle (message)
  (loop for handler in *handlers*
	when (handles-p handler message)
	append (let ((result (handle handler message)))
		 (if (listp result)
		     result
		   (list result)))))

(defun add-handler (handler)
  (push handler *handlers*))
