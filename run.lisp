#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :cl-json)

(load "brain.lisp")
(in-package :com.aragaer.pa-brain)

(translator-connect)
(format t "~a~%" (translate-pa2human "ready"))
(handler-case
 (main-loop)
 #+sbcl
 (sb-sys:interactive-interrupt () nil))
