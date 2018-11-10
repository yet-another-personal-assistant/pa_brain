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

(defun handle-command (message)
  (if (string= "switch-user" (assoc-value :command message))
      (setf *active-user* (assoc-value :user message)))
  nil)

(defun handle-event (message)
  (if (string= "new-day" (assoc-value :event message))
      `(((:intent . "good morning")
	 (:from . ,(assoc-value :to message))
	 (:to . ,(assoc-value :from message))))))

(defun handle-user-message (message human2pa)
  (let* ((from (assoc-value :from message))
	 (user (assoc-value :user from)))
    (if (string= *active-user* user)
	(let* ((text (assoc-value :message message))
	       (intent (funcall human2pa text)))
	  `(((:intent . ,(react intent))
	     (:from . ,(assoc-value :to message))
	     (:to . ,(assoc-value :from message))))))))

(defun translate-to-human (message pa2human)
  (if (assoc :intent message)
      (let ((intent (assoc :intent message)))
	(acons :message (funcall pa2human (cdr intent))
	       (remove intent message)))
      message))

(defun handle-message (message &key pa2human human2pa)
  (mapcar #'(lambda (message) (translate-to-human message pa2human))
	  (cond
	    ((assoc :command message) (handle-command message))
	    ((assoc :event message) (handle-event message))
	    (t (handle-user-message message human2pa)))))
