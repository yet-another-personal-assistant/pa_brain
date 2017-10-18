(load "package.lisp")

(load "translate.lisp")
(load "commands.lisp")
(load "connect.lisp")
(load "utils.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *keep-going* t)
(defvar *tg-owner* nil)

(add-top-level-command "hello" (just-reply "hello"))
(add-top-level-command "goodbye" (just-reply "goodbye"))
(add-top-level-command "unintelligible" (just-reply "failed to parse"))

(defun brain-output (line)
  (json:encode-json-plist (list :from "pa" :text line :chat_id *tg-owner*) *brain-io*)
  (format *brain-io* "~%"))

(defun brain-input ()
  (handler-case
   (let ((message (json:decode-json *brain-io*)))
     (aif (assoc :intent message)
	  (cdr it)
	  (translate-human2pa (cdr (assoc :text message)))))
   (end-of-file () (progn
		     (brain-accept)
		     (brain-input)))))

(defun brain-output* (line-or-lines)
  (if (listp line-or-lines)
      (mapcar 'brain-output line-or-lines)
    (brain-output line-or-lines)))

(defun main-loop ()
  (progn
    (translator-connect)
    (brain-accept)
    (loop while *keep-going*
	  do (brain-output* (process (brain-input) *top-level-commands*)))))
