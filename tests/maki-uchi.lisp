(in-package :cl-user)

(load #P"maki-uchi.lisp")
(defpackage maki-uchi-test
  (:use :cl
	:prove
	:json
	:com.aragaer.pa-brain))

(in-package #:maki-uchi-test)
(load #P"test-utils.lisp")
(setf *thought-class-under-test* 'maki-uchi-thought)

(defun verify-messages (text messages)
  (let ((event (make-event-from-intent text))
	(a-thought (make-instance 'maki-uchi-thought)))
    (process a-thought event)
    (react a-thought event)
    (is (getf event :response) messages)))

(defvar *status-requested* nil)
(defvar *status-reported* "")

(plan nil)
(cl-mock:with-mocks ()
		    (cl-mock:if-called 'com.aragaer.pa-brain:maki-uchi-status
				       (lambda (arg)
					 (declare (ignore arg))
					 (setf *status-requested* t)
					 '("makiuchi last never")))
		    (cl-mock:if-called 'com.aragaer.pa-brain:maki-uchi-log
				       (lambda (arg)
					 (setf *status-reported* arg)
					 '("good" "makiuchi last today")))
		    (verify-messages "hello" nil)
		    (verify-messages "cron event" nil)
		    (is *status-requested* nil)
		    (verify-messages "maki-uchi status" '("makiuchi last never"))
		    (is *status-requested* t)
		    (is *status-reported* "")
		    (verify-messages "maki-uchi log 10" '("good" "makiuchi last today"))
		    (is *status-reported* "10"))
(finalize)
