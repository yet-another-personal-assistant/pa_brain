#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :cl-json :silent t)

(load "package.lisp")
(load "socket.lisp")
(load "translate.lisp")

(in-package :com.aragaer.pa-brain)

(defvar *argv* (or
		#+CLISP *args*
		#+SBCL sb-ext:*posix-argv*
		#+LISPWORKS system:*line-arguments-list*
		#+CMU extensions:*command-line-words*
		nil))

(defmacro with-arg (key &rest body)
  `(let* ((pos (position ,key *argv* :test 'string-equal))
	  (value (if pos (elt *argv* (+ pos 1)))))
     (when value ,@body)))

(with-arg "--translator" (translator-connect value))

(defun get-reply (message)
  (translate-human2pa message)
  (if (string= message "Привет")
      "Ой, приветик!"
      "unknown"))

(loop for request = (json:decode-json)
   for reply = (get-reply (cdr (assoc :message request)))
   do (json:with-object ()
	(json:encode-object-member :message reply)
	(json:as-object-member (:from) (json:encode-json (cdr (assoc :to request))))
	(json:as-object-member (:to) (json:encode-json (cdr (assoc :from request)))))
   do (format t "~%"))
