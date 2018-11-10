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

(defun assoc-value (key a-list)
  (cdr (assoc key a-list)))

(defvar *active-user* nil)

(defun handle-message (message &key pa2human human2pa)
  (if (assoc :command message)
      (if (string= "switch-user" (assoc-value :command message))
	  (setf *active-user* (assoc-value :user message)))
      (if (not (assoc :event message))
	  (let* ((from (assoc-value :from message))
		 (user (assoc-value :user from)))
	    (if (string= *active-user* user)
		(let* ((text (assoc-value :message message))
		       (intent (funcall human2pa text)))
		  `((:message . ,(funcall pa2human (react intent)))
		    (:from . ,(assoc-value :to message))
		    (:to . ,(assoc-value :from message)))))))))
