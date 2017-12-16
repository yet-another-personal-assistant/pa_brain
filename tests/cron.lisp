(in-package :cl-user)

(load #P"cron.lisp")
(defpackage cron-test
  (:use :cl
	:prove
	:com.aragaer.pa-brain))

(in-package #:cron-test)
(load #P"test-utils.lisp")

(defun verify-modifiers-for (intent modifiers
				    &optional (thought (make-instance 'scheduled-reminder)))
  (let ((event (make-event-from-intent intent)))
    (react thought event)
    (is (getf event :modifiers) modifiers)))

(defun verify-messages-for (modifiers messages)
  (let ((event (make-event-from-intent "" modifiers))
	(a-reminder (make-instance 'scheduled-reminder)))
    (process a-reminder event)
    (is (getf event :response) messages)))

(plan nil)
(verify-modifiers-for "hello" nil)
(verify-modifiers-for "cron event" (acons :scheduled "event" nil))
(let ((event (make-event-from-intent "cron event")))
  (setf (getf event :modifiers) (acons :test t nil))
  (react (make-instance 'scheduled-reminder) event)
  (is (getf event :modifiers) (acons :test t nil)))

(verify-messages-for (acons :scheduled "something" nil) '("something"))
(verify-messages-for nil nil)
(finalize)
