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
  (subtest "no active user"
           (set-user nil)
           (is (handle-message message) ()))

  (subtest "no-op command"
           (set-user nil)
           (is (handle-message '((:command . "no-op") (:user "user1"))) ())
           (is (handle-message message) ()))

  (subtest "active user"
           (set-user nil)
           (handle-message activate-message)
           (handle-message `((:event . "presence") (:from . ,from)))
           (let* ((result (handle-message message))
                  (msg (car result)))
             (is (assoc :message msg) '(:message . "hello"))
             (is (assoc :from msg) `(:from . ,to))
             (is (assoc :to msg) `(:to . ,from))))

  (subtest "other user"
           (set-user "user2")
           (is (handle-message message) ()))

  (subtest "other user presence"
           (set-user "user1")
           (handle-message `((:event . "presence") (:from . ,from)))
           (handle-message '((:event . "presence")
                             (:from . ((:user . "user2") (:channel . "other channel")))))
           (let* ((result (handle-message message))
                  (msg (car result)))
             (is (assoc :message msg) '(:message . "hello"))
             (is (assoc :from msg) `(:from . ,to))
             (is (assoc :to msg) `(:to . ,from)))))
(finalize)
