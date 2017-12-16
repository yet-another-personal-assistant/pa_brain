(in-package :cl-user)

(load #P"unknown.lisp")
(defpackage unknown-test
  (:use :cl
	:prove
	:com.aragaer.pa-brain))

(in-package #:unknown-test)
(load #P"test-utils.lisp")

(defun verify-modifiers-for (intent modifiers
				    &optional (thought (make-instance 'dont-understand)))
  (let ((event (make-event-from-intent intent)))
    (react thought event)
    (is (getf event :modifiers) modifiers)))

(defun verify-messages-for (modifiers messages)
  (let ((event (make-event-from-intent "" modifiers))
	(a-reminder (make-instance 'dont-understand)))
    (process a-reminder event)
    (is (getf event :response) messages)))

(plan nil)
(verify-modifiers-for "unintelligible" (acons :dont-understand t nil))
(verify-modifiers-for "hello" nil)

(verify-messages-for (acons :dont-understand t nil) '("failed to parse"))
(verify-messages-for nil nil)
(let ((event (make-event-from-intent "" (acons :dont-understand t nil)))
      (a-thought (make-instance 'dont-understand)))
  (setf (getf event :response) '("yo"))
  (process a-thought event)
  (is (getf event :response) '("yo" "failed to parse")))
(finalize)
