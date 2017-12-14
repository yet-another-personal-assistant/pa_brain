(in-package :cl-user)

(load #P"japanese.lisp")
(defpackage japanese-test
  (:use :cl
	:prove
	:cl-mock
	:com.aragaer.pa-brain))

(in-package #:japanese-test)
(load #P"test-utils.lisp")

(defun verify-modifiers-for (intent modifiers
				    &optional (thought (make-instance 'japanese-reminder)))
  (let ((event (make-event-from-intent intent)))
    (react thought event)
    (is (getf event :modifiers) modifiers)))

(defun verify-messages-for (modifiers messages)
  (let ((event (make-event-from-intent "" modifiers))
	(a-reminder (make-instance 'japanese-reminder)))
    (process a-reminder event)
    (is (getf event :response) messages)))

(plan nil)
(verify-modifiers-for "japanese report done" (acons :japanese-done t nil))
(verify-modifiers-for "hello" nil)
(verify-modifiers-for "cron study japanese" (acons :japanese-request t nil))
(verify-modifiers-for "yes" nil)
(verify-modifiers-for "no" nil)
(verify-modifiers-for "japanese report anki" (acons :japanese-done t nil))
(verify-modifiers-for "japanese report duolingo" (acons :japanese-done t nil))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (make-event-from-intent "japanese report done"))
  (verify-modifiers-for "cron study japanese" (acons :japanese-request nil nil) thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (make-event-from-intent "japanese report anki"))
  (verify-modifiers-for "cron study japanese" (acons :japanese-request '("duolingo") nil) thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (make-event-from-intent "japanese report duolingo"))
  (verify-modifiers-for "cron study japanese" (acons :japanese-request '("anki") nil) thought))

(let ((thought (make-instance 'japanese-reminder))
      (this-time (get-universal-time)))
  (react thought (make-event-from-intent "japanese report done"))
  (with-unlock
   (dflet ((get-universal-time () this-time))
	  (verify-modifiers-for "cron study japanese" (acons :japanese-request nil nil) thought))
   (dflet ((get-universal-time () (+ this-time (* 24 60 60))))
	  (verify-modifiers-for "cron study japanese" (acons :japanese-request t nil) thought))))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (make-event-from-intent "cron study japanese"))
  (verify-modifiers-for "yes" (acons :japanese-done t nil) thought)
  (verify-modifiers-for "yes" nil thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (make-event-from-intent "cron study japanese"))
  (verify-modifiers-for "no" (acons :japanese-done nil nil) thought)
  (verify-modifiers-for "no" nil thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (make-event-from-intent "cron study japanese"))
  (verify-modifiers-for "japanese report done" (acons :japanese-done t nil) thought)
  (verify-modifiers-for "yes" nil thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (make-event-from-intent "cron study japanese"))
  (verify-modifiers-for "yes" (acons :japanese-done t nil) thought)
  (verify-modifiers-for "cron study japanese" (acons :japanese-request nil nil) thought)
  (verify-modifiers-for "yes" nil thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (make-event-from-intent "cron study japanese"))
  (verify-modifiers-for "no" (acons :japanese-done nil nil) thought)
  (verify-modifiers-for "cron study japanese" (acons :japanese-request t nil) thought))

(verify-messages-for (acons :japanese-done t nil) '("good"))
(verify-messages-for nil nil)
(verify-messages-for (acons :japanese-request nil nil) nil)
(verify-messages-for (acons :japanese-request t nil) '("japanese status request"))
(verify-messages-for (acons :japanese-done nil nil) '("bad"))
(verify-messages-for (acons :japanese-request '("anki") nil) '("japanese status request anki"))

(finalize)
