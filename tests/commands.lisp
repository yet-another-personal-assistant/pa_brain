(in-package :cl-user)

(load #P"brain.lisp")

(defpackage command-test
  (:use :cl
        :prove
        :com.aragaer.pa-brain))

(in-package #:command-test)
(plan nil)

(let* ((from '((:user . "user") (:channel . "channel")))
       (to '((:user . "niege") (:channel . "brain")))
       (presence `((:event . "presence") (:from . ,from) (:to . ,to)))
       (event `((:event . "new-day") (:to . ,to)))
       (result nil)
       (msg nil))

  (subtest "say with active channel"
	   (set-user "user")
	   (handle-message presence)
	   (setf result (handle-message '((:command . "say") (:text . "hello"))))
	   (setf msg (car result))
	   (is (assoc :message msg) (cons :message "hello"))
	   (is (assoc :from msg) (cons :from to))
	   (is (assoc :to msg) (cons :to from)))

  (when nil
	   (set-user "user")
	   (setf result (handle-message event))
	   (is result nil)
	   (setf result (handle-message presence))
	   (setf msg (car result))
	   (is (assoc :message msg) (cons :message "good morning"))
	   (is (assoc :from msg) (cons :from to))
	   (is (assoc :to msg) (cons :to from))))

(finalize)
