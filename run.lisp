#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :cl-json :silent t)

(load "package.lisp")

(in-package :com.aragaer.pa-brain)

(defun get-reply (message)
  (if (string= message "hello")
      "hello"
      "unknown"))

(loop for request = (json:decode-json)
   for reply = (get-reply (cdr (assoc :text request)))
   do (json:with-object ()
	(json:encode-object-member :text reply)
	(json:as-object-member (:from) (json:encode-json (cdr (assoc :to request))))
	(json:as-object-member (:to) (json:encode-json (cdr (assoc :from request)))))
   do (format t "~%"))
