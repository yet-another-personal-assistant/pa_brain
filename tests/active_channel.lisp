(in-package :cl-user)

(load #P"brain.lisp")

(defpackage active-channel-test
  (:use :cl
        :prove
        :com.aragaer.pa-brain))

(in-package #:active-channel-test)
(plan nil)

(let* ((from '((:user . "user") (:channel . "channel")))
       (from2 '((:user . "user") (:channel . "channel2")))
       (to '((:user . "niege") (:channel . "brain")))
       (presence-msg `((:event . "presence") (:from . ,from) (:to . ,to)))
       (gone-msg `((:event . "gone") (:from . ,from) (:to . ,to)))
       (gone-2-msg `((:event . "gone") (:from . ,from2) (:to . ,to)))
       (command `((:command . "say") (:text . "test")))
       (result nil)
       (msg nil))

  (subtest "presence"
	   (set-user "user")
	   (setf result (handle-message presence-msg))
	   (is result '())
	   (setf result (handle-message command))
	   (setf msg (car result))
	   (is (cdr (assoc :message msg)) "test"))
	   (is (cdr (assoc :to msg)) from)

  (subtest "gone"
	   (set-user "user")
	   (setf result (handle-message presence-msg))
	   (is result '())
	   (setf result (handle-message gone-msg))
	   (is result '())
	   (setf result (handle-message command))
	   (is result '())

  (subtest "returned"
	   (set-user "user")
	   (handle-message presence-msg)
	   (handle-message gone-msg)
	   (setf result (handle-message presence-msg))
	   (is result '())
	   (setf result (handle-message command))
	   (setf msg (car result))
	   (is (cdr (assoc :message msg)) "test")
	   (is (cdr (assoc :to msg)) from)))

  (subtest "other channel gone"
	   (set-user "user")
	   (handle-message presence-msg)
	   (handle-message gone-2-msg)
	   (setf result (handle-message command))
	   (setf msg (car result))
	   (is (cdr (assoc :message msg)) "test")
	   (is (cdr (assoc :to msg)) from)))


(finalize)
