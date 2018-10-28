#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :cl-json :silent t)
(ql:quickload :unix-opts :silent t)

(load "brain.lisp")
(load "package.lisp")
(load "socket.lisp")

(in-package :com.aragaer.pa-brain)

(opts:define-opts
  (:name :translator
	 :long "translator"
	 :arg-parser #'identity))

(multiple-value-bind (options free-args)
  (opts:get-opts)
  (if (getf options :translator)
    (translator-connect (getf options :translator))))

(loop for request = (json:decode-json)
   for text = (cdr (assoc :message request))
   if text
     do (json:with-object ()
	  (json:encode-object-member :message (get-reply text))
	  (json:as-object-member (:from) (json:encode-json (cdr (assoc :to request))))
	  (json:as-object-member (:to) (json:encode-json (cdr (assoc :from request)))))
     and do (format *standard-output* "~%")
     and do (finish-output *standard-output*))
