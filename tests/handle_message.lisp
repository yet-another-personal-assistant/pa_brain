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

(defun human2pa (text)
  (setf *text* text)
  "hello")

(defun pa2human (intent)
  (setf *intent* intent)
  "text")

(setf *active-user* "user1")

(let* ((from '((:user . "user1") (:channel . "channel")))
       (to '((:user . "niege") (:channel . "brain")))
       (message `((:message . "hi") (:from . ,from) (:to . ,to))))
  (let* ((result (handle-message message :human2pa 'human2pa :pa2human 'pa2human))
	 (msg (car result)))
    (is (assoc :message msg) (cons :message "text"))
    (is (assoc :from msg) (cons :from to))
    (is (assoc :to msg) (cons :to from))
    (is *intent* (react "hello"))
    (is *text* "hi")))

(defun unintelligible (text)
  (setf *text* text)
  "unintelligible")

(let* ((from '((:user . "user1") (:channel . "channel")))
       (to '((:user . "niege") (:channel . "brain")))
       (message `((:message . "hi") (:from . ,from) (:to . ,to))))
  (let* ((result (handle-message message :human2pa 'unintelligible :pa2human 'pa2human))
	 (msg (car result)))
    (is (assoc :message msg) (cons :message "text"))
    (is (assoc :from msg) (cons :from to))
    (is (assoc :to msg) (cons :to from))
    (is *intent* (react "x"))
    (is *text* "hi")))

(finalize)
