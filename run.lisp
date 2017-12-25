#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :alexandria :silent t)
(ql:quickload :cl-conspack :silent t)
(ql:quickload :exit-hooks :silent t)
(ql:quickload :cl-json :silent t)
(ql:quickload :uiop :silent t)
(ql:quickload :cl-yaml :silent t)

(load "config.lisp")

(load "brain.lisp")
(load "cron.lisp")
(load "state.lisp")
(load "greeter.lisp")
(load "unknown.lisp")
(load "utils.lisp")
(load "maki-uchi.lisp")
(load "japanese.lisp")

(in-package :com.aragaer.pa-brain)

(defmacro do-make-instance (cls)
  `#'(lambda () (make-instance ,cls)))

(defun main (&optional args)
  (declare (ignore args))
  (process-config)

  (if *config*
      (aif (gethash "modules" *config*)
	   (when (member "maki-uchi" it :test 'string-equal)
	     (setf *maki-uchi-log-file* (gethash "maki-uchi" *config*)))
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
   (sb-sys:interactive-interrupt () nil)))
