#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(with-open-file (*standard-output* "/dev/null" :direction :output
                                   :if-exists :supersede)
		(ql:quickload :alexandria)
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
(load "unknown.lisp")
(load "utils.lisp")

(in-package :com.aragaer.pa-brain)

(process-config)

(defmacro do-make-instance (cls)
  `#'(lambda () (make-instance ,cls)))

(if *config*
    (aif (gethash "modules" *config*)
	 (when (member "japanese" it :test 'string-equal)
	   (add-default-thought :japanese-reminder (do-make-instance 'japanese-reminder)))))

(add-default-thought :old (do-make-instance 'old-handler))
(add-default-thought :cron (do-make-instance 'scheduled-reminder))
(add-default-thought :greeter (do-make-instance 'greeter))
(add-default-thought :dont-understand (do-make-instance 'dont-understand))

(init-thoughts)

(handler-case
 (main-loop)
 #+sbcl
 (sb-sys:interactive-interrupt () nil))
