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
    (:name :router
           :long "router"
           :arg-parser #'identity)
    (:name :translator
           :long "translator"
           :arg-parser #'identity))

(defvar *router-input* *standard-input*)
(defvar *router-output* *standard-output*)
(defvar *router-addr* nil)

(defun router-connect ()
  (format *error-output* "Connecting to router at ~a~%" *router-addr*)
  (let ((router-io (create-socket-stream *router-addr*)))
    (setf *router-input* router-io)
    (setf *router-output* router-io)))

(multiple-value-bind (options free-args)
    (opts:get-opts)
  (when-let ((router-addr (getf options :router)))
    (setf *router-addr* router-addr)
    (router-connect))
  (when-let ((translator-addr (getf options :translator)))
    (setf *translator-addr* translator-addr)
      (translator-connect)))

(setf *pa2human* 'translate-pa2human
      *human2pa* 'translate-human2pa)

(defun get-message ()
  (handler-case (json:decode-json *router-input*)
    (end-of-file (se)
      (if *router-addr*
          (progn
            (router-connect)
            (get-message))
          (progn
            (format *error-output* "STDIO closed, exiting~%")
            (quit))))))

(defun send-message (response)
  (handler-case (progn (json:encode-json response *router-output*)
                       (format *router-output* "~%")
                       (finish-output *router-output*))
    #+sbcl
    (sb-int:simple-stream-error (se)
      (if *router-addr*
          (progn
            (router-connect)
            (send-message response))
          (progn
            (format *error-output* "STDIO closed, exiting~%")
            (quit))))))

(loop for message = (get-message)
   do (format *error-output* "Got [~a]~%" message)
   do (loop for response in (handle-message message)
         do (send-message response)))
