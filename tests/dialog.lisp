(in-package :cl-user)

(load #P"dialog.lisp")
(defpackage dialog-test
  (:use :cl
	:prove
	:com.aragaer.pa-brain))

(in-package #:dialog-test)
(load #P"test-utils.lisp")

(plan nil)
(let* ((result nil)
       (data nil)
       (dialog (make-instance 'dialog
			      :name "dialog"
			      :triggers (pairlis '("yes" "no")
						 `(,#'(lambda (thought event f-data)
							(declare (ignore thought event))
							(setf result t)
							(setf data f-data))
						   ,#'(lambda (thought event f-data)
							(declare (ignore thought event))
							(setf result nil)
							(setf data f-data)))))))
  (react dialog (make-event-from-intent "yes"))
  (is result t)
  (is data "")
  (react dialog (make-event-from-intent "no"))
  (is result nil)
  (is data "")
  (react dialog (make-event-from-intent "yes 10"))
  (is result t)
  (is data "10")
  (react dialog (make-event-from-intent "no red"))
  (is result nil)
  (is data "red"))

(let ((dialog (make-instance 'dialog
			     :name "dialog"
			     :triggers (acons "ok" #'(lambda (dialog &rest args)
						       (declare (ignore args))
						       (mark-finished dialog)) nil))))
  (react dialog (make-event-from-intent "huh"))
  (isnt (finished-p dialog) t)
  (react dialog (make-event-from-intent "ok"))
  (is (finished-p dialog) t))
(finalize)
