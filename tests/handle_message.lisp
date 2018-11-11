(in-package :cl-user)

(load #P"brain.lisp")

(defpackage handle-message-test
  (:use :cl
        :prove
        :com.aragaer.pa-brain))

(in-package #:handle-message-test)
(plan nil)

(defvar *text* nil)
(defvar *intent* nil)

(let* ((from '((:user . "user1") (:channel . "channel")))
       (to '((:user . "niege") (:channel . "brain")))
       (message `((:message . "hi") (:from . ,from) (:to . ,to)))
       (result nil)
       (msg nil))
  (subtest "handle hello"
	   (setf *human2pa* #'(lambda (text) (setf *text* text) "hello"))
	   (setf *pa2human* #'(lambda (intent) (setf *intent* intent) "text"))
	   (set-user "user1")
	   (setf result (handle-message message))
	   (setf msg (car result))
	   (is (assoc :message msg) (cons :message "text"))
	   (is (assoc :from msg) (cons :from to))
	   (is (assoc :to msg) (cons :to from))
	   (is *intent* (react "hello"))
	   (is *text* "hi"))

  (subtest "handle unintelligible"
	   (setf *human2pa* #'(lambda (text) (setf *text* text) "unintelligible"))
	   (setf *pa2human* #'(lambda (intent) (setf *intent* intent) "text"))
	   (set-user "user1")
	   (setf result (handle-message message))
	   (setf msg (car result))
	   (is (assoc :message msg) (cons :message "text"))
	   (is (assoc :from msg) (cons :from to))
	   (is (assoc :to msg) (cons :to from))
	   (is *intent* (react "x"))
	   (is *text* "hi")))

(finalize)
