(in-package :cl-user)

(load #P"cron.lisp")
(defpackage cron-test
  (:use :cl
	:prove
	:com.aragaer.pa-brain))

(in-package #:cron-test)
(load #P"test-utils.lisp")
(setf *thought-class-under-test* 'scheduled-reminder)

(defun verify-modifiers-for-event (text modifiers)
  (let ((event (make-event-from-text nil)))
    (setf (getf event :event) text)
    (react (make-instance 'scheduled-reminder) event)
    (is (getf event :modifiers) modifiers)))

(defun verify-messages-for-event (text modifiers messages)
  (let ((event (make-event-from-intent nil modifiers))
	(a-thought (make-instance 'scheduled-reminder)))
    (setf (getf event :event) text)
    (process a-thought event)
    (is (getf event :response) messages)))

(plan nil)
(verify-modifiers-for "hello" nil)
(verify-modifiers-for "cron event" nil)
(verify-modifiers-for-event "cron event" (acons :scheduled "event" nil))
(let ((event (make-event-from-intent "cron event")))
  (setf (getf event :modifiers) (acons :test t nil))
  (react (make-instance 'scheduled-reminder) event)
  (is (getf event :modifiers) (acons :test t nil)))

(verify-messages-for-event "cron something" (acons :scheduled "something" nil) '("something"))
(verify-messages-for nil nil)
(verify-messages-for-event "cron somethin" nil nil)

(let ((event (make-event nil nil nil))
      (reminder (make-instance 'scheduled-reminder)))
  (setf (getf event :event) "cron go to bed")
  (react reminder event)
  (is (getf event :modifiers) (acons :scheduled "go to bed" nil))
  (process reminder event)
  (is (getf event :response) '("go to bed")))
(finalize)
