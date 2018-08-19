#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :cl-json :silent t)

(load "package.lisp")

(in-package :com.aragaer.pa-brain)

(json:with-object ()
  (json:encode-object-member :text "pong")
  (json:as-object-member (:from) (json:encode-json-plist `(:user "niege" :channel "brain")))
  (json:as-object-member (:to) (json:encode-json-plist `(:user "user" :channel "channel"))))
(format t "~%")
