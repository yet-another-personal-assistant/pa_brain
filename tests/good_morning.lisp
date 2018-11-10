(in-package :cl-user)

(load #P"brain.lisp")

(defpackage good-morning-test
  (:use :cl
        :prove
        :com.aragaer.pa-brain))

(in-package #:good-morning-test)
(plan nil)

(setf *active-user* "user")

(let* ((from '((:user . "user") (:channel . "channel")))
       (to '((:user . "niege") (:channel . "brain")))
       (event `((:event . "new-day") (:from . ,from) (:to . ,to))))
  (let* ((result (handle-message event :human2pa 'identity :pa2human 'identity))
	 (msg (car result)))
    (is (assoc :message msg) (cons :message "good morning"))
    (is (assoc :from msg) (cons :from to))
    (is (assoc :to msg) (cons :to from))))

(finalize)
