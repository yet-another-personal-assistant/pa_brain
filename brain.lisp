(load "package.lisp")

(load "translate.lisp")
(load "commands.lisp")
(load "socket.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *keep-going* t)
(defvar *brain-io* nil)
(defvar *brain-socket-path* "/tmp/pa_brain")
(defvar *brain-socket* (create-server-socket *brain-socket-path*))
(defvar *tg-owner* nil)

(defun brain-accept ()
  (setq *brain-io* (accept-socket-stream *brain-socket*)))

(add-top-level-command "hello" (just-reply "hello"))
(add-top-level-command "goodbye" (just-reply "goodbye"))
(add-top-level-command "unintelligible" (just-reply "failed to parse"))

(defun brain-output (line)
  (json:encode-json-plist (list :from "pa" :text line :chat_id *tg-owner*) *brain-io*)
  (format *brain-io* "~%"))

(defun brain-input ()
  (handler-case
   (let ((message (json:decode-json *brain-io*)))
     (if (assoc :intent message)
	 (cdr (assoc :intent message))
       (translate-human2pa (cdr (assoc :text message)))))
   (end-of-file () (progn
		     (brain-accept)
		     (brain-input)))))

(defun brain-output* (line-or-lines)
  (if (listp line-or-lines)
      (mapcar 'brain-output line-or-lines)
    (brain-output line-or-lines)))

(defun main-loop ()
  (loop while *keep-going*
	do (brain-output* (process (brain-input) *top-level-commands*))))
