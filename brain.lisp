(load "package.lisp")

(load "translate.lisp")
(load "commands.lisp")
(load "connect.lisp")
(load "config.lisp")
(load "utils.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *keep-going* t)

(add-top-level-command "hello" (just-reply "hello"))
(add-top-level-command "goodbye" (just-reply "goodbye"))
(add-top-level-command "unintelligible" (just-reply "failed to parse"))

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

(defun brain-output (line target)
  (json:encode-json-plist (append (list :from "pa" :text line) target) *brain-io*)
  (format *brain-io* "~%"))

(defun brain-output* (line-or-lines target)
  (if (listp line-or-lines)
      (loop for line in line-or-lines
	    do (brain-output line target))
    (brain-output line-or-lines target)))

(defun main-loop ()
  (translator-connect)
  (brain-accept)
  (loop while *keep-going*
	with message
	do (setq message (brain-input))
	do (brain-output* (process (get-intent message) *top-level-commands*)
			  (build-target message))))
