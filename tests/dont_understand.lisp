(in-package :cl-user)

(load #P"unknown.lisp")
(defpackage unknown-test
  (:use :cl
	:prove
	:com.aragaer.pa-brain))

(in-package #:unknown-test)
(load #P"test-utils.lisp")
(setf *thought-class-under-test* 'dont-understand)

(plan nil)
(verify-modifiers-for "unintelligible" (acons :dont-understand t nil))
(verify-modifiers-for "unintelligible stuff" (acons :dont-understand "stuff" nil))
(verify-modifiers-for "hello" nil)
(verify-modifiers-for "unknown command" nil)

(verify-messages-for (acons :dont-understand t nil) '("failed to parse"))
(verify-messages-for nil nil)

(let ((event (make-event-from-intent "" (acons :dont-understand t nil)))
      (a-thought (make-instance 'dont-understand)))
  (setf (getf event :response) '("yo"))
  (process a-thought event)
  (is (getf event :response) '("yo" "failed to parse")))

(let ((event (make-event nil nil nil))
      (a-thought (make-instance 'dont-understand)))
  (setf (getf event :event) "cron go to bed")
  (setf (getf event :modifiers) (acons :scheduled "go to bed" nil))
  (react a-thought event)
  (process a-thought event)
  (is (getf event :response) nil))

(let ((event1 (make-event-from-intent "unknown command"))
      (event2 (make-event-from-intent "unknown command"))
      (a-thought (make-instance 'dont-understand)))
  (react a-thought event1)
  (process a-thought event1)
  (react a-thought event2)
  (setf (getf event2 :modifiers) (acons :hello t nil))
  (process a-thought event2)
  (is (getf event1 :response) '("unknown command \"unknown command\""))
  (is (getf event1 :response) '("unknown command \"unknown command\"")))
(finalize)
