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
(load "utils.lisp")

(in-package :com.aragaer.pa-brain)

(process-config)

(aif (gethash "modules" *config*)
     (progn
       (when (member "japanese" it :test 'string-equal)
	 (add-default-thought :japanese-reminder #'(lambda () (make-instance 'japanese-reminder))))))

(add-default-thought :greeter #'(lambda () (make-instance 'greeter)))
(add-default-thought :old #'(lambda () (make-instance 'old-handler)))

(init-thoughts)

(handler-case
 (main-loop)
 #+sbcl
 (sb-sys:interactive-interrupt () nil))
