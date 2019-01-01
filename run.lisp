#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :alexandria :silent t)
(ql:quickload :cl-json :silent t)
(ql:quickload :unix-opts :silent t)

(load "brain.lisp")
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

(setf *pa2human* 'translate-pa2human
      *human2pa* 'translate-human2pa)

(loop for message = (json:decode-json)
   do (format *error-output* "Got [~a]~%" message)
   do (loop for response in (handle-message message)
         do (json:encode-json response)
         do (format *standard-output* "~%")
         do (finish-output *standard-output*)))
