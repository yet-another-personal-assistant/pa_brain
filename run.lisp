#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(with-open-file (*standard-output* "/dev/null" :direction :output
                                   :if-exists :supersede)
		(ql:quickload :cl-conspack)
		(ql:quickload :exit-hooks)
		(ql:quickload :cl-json)
		(ql:quickload :uiop)
		(ql:quickload :cl-yaml))

(load "config.lisp")

(load "brain.lisp")
(load "cron.lisp")
(load "state.lisp")
(load "greeter.lisp")

(in-package :com.aragaer.pa-brain)

(process-config)

(add-thought (make-instance 'greeter))
(handler-case
 (main-loop)
 #+sbcl
 (sb-sys:interactive-interrupt () nil))
