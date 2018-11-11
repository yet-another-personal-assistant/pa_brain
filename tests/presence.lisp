(in-package :cl-user)

(load #P"brain.lisp")

(defpackage presence-test
  (:use :cl
        :prove
        :com.aragaer.pa-brain))

(in-package #:presence-test)
(plan nil)

(set-user "user")

(let* ((from '((:user . "user") (:channel . "channel")))
       (to '((:user . "niege") (:channel . "brain")))
       (message `((:event . "presence") (:from . ,from) (:to . ,to))))
  (let ((result (handle-message message)))
    (is result '())))

(finalize)
