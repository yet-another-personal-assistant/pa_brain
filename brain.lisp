(load "package.lisp")

(load "translate.lisp")
(load "commands.lisp")
(load "connect.lisp")
(load "config.lisp")
(load "utils.lisp")
(load "state.lisp")
(load "event.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *keep-going* t)

(add-top-level-command "goodbye" (just-reply "goodbye"))

(defun get-intent (message)
  (aif (assoc :intent message)
       (cdr it)
       (translate-human2pa (assoc-value :text message))))

(defun tg-target (from)
  (list :to "telegram" :chat_id (assoc-value :id from)))

(defun build-target (message)
  (let* ((from (assoc-value :from message))
	 (media (assoc-value :media from)))
    (cond ((string-equal media "telegram")
	   (tg-target from))
	  ((string-equal media "incoming")
	   (list :to "telegram" :chat_id (get-telegram-id)))
	  (t (list :to media)))))

(defun brain-input ()
  (handler-case
   (json:decode-json *brain-io*)
   (end-of-file () (progn
		     (brain-accept)
		     (brain-input)))))

(defun brain-output (lines target)
  (let ((messages (mapcar 'translate-pa2human lines)))
    (json:encode-json-plist (append `(:from "pa" :text ,messages) target) *brain-io*)
    (format *brain-io* "~%")))

(add-thought (make-instance 'old-handler))

(defun main-loop ()
  (translator-connect)
  (brain-accept)
  (loop while *keep-going*
	with message
	do (setq message (brain-input))
	with event
	do (setq event (make-event (get-intent message) nil nil))
	do (try-handle event)
	do (brain-output (ensure-list (getf event :response))
			 (build-target message))))
