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
(verify-modifiers-for "hello" nil)

(verify-messages-for (acons :dont-understand t nil) '("failed to parse"))
(verify-messages-for nil nil)

(let ((event (make-event-from-intent "" (acons :dont-understand t nil)))
      (a-thought (make-instance 'dont-understand)))
  (setf (getf event :response) '("yo"))
  (process a-thought event)
  (is (getf event :response) '("yo" "failed to parse")))
(finalize)
