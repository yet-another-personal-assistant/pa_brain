(in-package :cl-user)

(load #P"admin.lisp")
(defpackage admin-test
  (:use :cl
	:prove
	:json
	:com.aragaer.pa-brain))

(in-package #:admin-test)
(load #P"test-utils.lisp")
(setf *thought-class-under-test* 'admin-thought)

(defun verify-messages (text messages)
  (let ((event (make-event-from-intent text))
	(a-thought (make-instance 'admin-thought)))
    (process a-thought event)
    (react a-thought event)
    (is (getf event :response) messages)))

(defvar *refresh-called* nil)

(plan nil)
(cl-mock:with-mocks ()
		    (cl-mock:if-called 'com.aragaer.pa-brain:translator-refresh
				       (lambda (arg)
					 (declare (ignore arg))
					 (setf *refresh-called* t)
					 "done"))
		    (verify-messages "hello" nil)
		    (verify-messages "cron event" nil)
		    (is *refresh-called* nil)
		    (verify-messages "reload phrases" '("done"))
		    (is *refresh-called* t))
(finalize)
