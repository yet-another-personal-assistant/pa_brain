#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :cl-json)
(ql:quickload :uiop)
(ql:quickload :cl-yaml)

(load "config.lisp")

(load "brain.lisp")
(load "cron.lisp")
(load "state.lisp")
(load "greeter.lisp")

(in-package :com.aragaer.pa-brain)

(process-config)

(add-handler (make-instance 'greeter))
(handler-case
 (main-loop)
 #+sbcl
 (sb-sys:interactive-interrupt () nil))
