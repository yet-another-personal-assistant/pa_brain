#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :cl-json)

(load "brain.lisp")
(in-package :com.aragaer.pa-brain)

(translator-connect)
(main-loop)
