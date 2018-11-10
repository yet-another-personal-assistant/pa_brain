(in-package :cl-user)

(load #P"brain.lisp")

(defpackage presence-test
  (:use :cl
        :prove
        :com.aragaer.pa-brain))

(in-package #:presence-test)
(plan nil)

(setf *active-user* "user")

(let* ((from '((:user . "user") (:channel . "channel")))
       (to '((:user . "niege") (:channel . "brain")))
       (message `((:event . "presence") (:from . ,from) (:to . ,to))))
  (let ((result (handle-message message :human2pa 'identity :pa2human 'identity)))
    (is result '())))

(finalize)
