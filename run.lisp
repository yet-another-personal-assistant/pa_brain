#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :cl-json :silent t)
(ql:quickload :unix-opts :silent t)

(load "package.lisp")
(load "socket.lisp")
(load "translate.lisp")

(in-package :com.aragaer.pa-brain)

(opts:define-opts
  (:name :translator
	 :long "translator"
	 :arg-parser #'identity))

(multiple-value-bind (options free-args)
  (opts:get-opts)
  (if (getf options :translator)
    (translator-connect (getf options :translator))))

(defun get-reply (message)
  (let ((intent (translate-human2pa message)))
    (translate-pa2human
     (cond ((string= intent "hello")
	    "hello")
	   (t
	    "unknown")))))

(loop for request = (json:decode-json)
   for reply = (get-reply (cdr (assoc :message request)))
   do (json:with-object ()
	(json:encode-object-member :message reply)
	(json:as-object-member (:from) (json:encode-json (cdr (assoc :to request))))
	(json:as-object-member (:to) (json:encode-json (cdr (assoc :from request)))))
   do (format t "~%"))
