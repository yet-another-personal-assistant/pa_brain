(in-package :cl-user)

(load #P"brain.lisp")

(defpackage active-user-test
  (:use :cl
        :prove
        :com.aragaer.pa-brain))

(in-package #:active-user-test)
(plan nil)

(let* ((from '((:user . "user1") (:channel . "channel")))
       (to '((:user . "niege") (:channel . "brain")))
       (message `((:message . "hello") (:from . ,from) (:to . ,to)))
       (activate-message `((:command . "switch-user") (:user . "user1"))))
  (setf *active-user* nil)
  (is (handle-message message :pa2human 'identity :human2pa 'identity) ())

  (setf *active-user* nil)
  (is (handle-message '((:command . "no-op") (:user "user1")) :pa2human 'identity :human2pa 'identity) ())
  (is *active-user* nil)

  (setf *active-user* nil)
  (handle-message activate-message)
  (is *active-user* "user1")
  ;(is (handle-message message :pa2human 'identity :human2pa 'identity) ())

  (setf *active-user* "user2")
  (is (handle-message message :pa2human 'identity :human2pa 'identity) ()))

(finalize)
