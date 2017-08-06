#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :cl-json)
(ql:quickload :uiop)
(ql:quickload :trivial-gray-streams)

(load "brain.lisp")
(load "telegram.lisp")
(in-package :com.aragaer.pa-brain)

(setf *brain-output* (make-instance 'telegram-output-stream))
(setf *brain-input* (make-instance 'telegram-input-stream))

(translator-connect)
(brain-output (translate-pa2human "ready"))
;(cl-user::quit)
(handler-case
 (main-loop)
 #+sbcl
 (sb-sys:interactive-interrupt () nil))