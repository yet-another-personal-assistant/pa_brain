(in-package :cl-user)

(load #P"japanese.lisp")
(defpackage japanese-test
  (:use :cl
	:prove
	:com.aragaer.pa-brain))

(in-package #:japanese-test)
(load #P"test-utils.lisp")

(setf *thought-class-under-test* 'japanese-reminder)

(plan nil)
(verify-modifiers-for-2 '(:event "japanese report done") nil)
(verify-modifiers-for-2 '(:intent "japanese report done") (acons :japanese-done t nil))
(verify-modifiers-for-2 '(:intent "hello") nil)
(verify-modifiers-for-2 '(:event "cron study japanese") (acons :japanese-request t nil))
(verify-modifiers-for-2 '(:intent "cron study japanese") nil)
(verify-modifiers-for "yes" nil)
(verify-modifiers-for "no" nil)
(verify-modifiers-for "japanese report anki" (acons :japanese-done t nil))
(verify-modifiers-for "japanese report duolingo" (acons :japanese-done t nil))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (make-event-from-intent "japanese report done"))
  (verify-modifiers-for-2 '(:event "cron study japanese")
			  (acons :japanese-request nil nil) thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (make-event-from-intent "japanese report done"))
  (react thought (build-event :event "new day"))
  (verify-modifiers-for-2 '(:event "cron study japanese")
			  (acons :japanese-request t nil) thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (make-event-from-intent "japanese report anki"))
  (verify-modifiers-for-2 '(:event "cron study japanese")
			  (acons :japanese-request '("duolingo") nil) thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (make-event-from-intent "japanese report duolingo"))
  (verify-modifiers-for-2 '(:event "cron study japanese")
			  (acons :japanese-request '("anki") nil) thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (build-event :event "cron study japanese"))
  (verify-modifiers-for "yes" (acons :japanese-done t nil) thought)
  (verify-modifiers-for "yes" nil thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (build-event :event "cron study japanese"))
  (verify-modifiers-for "no" (acons :japanese-done nil nil) thought)
  (verify-modifiers-for "no" nil thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (build-event :event "cron study japanese"))
  (verify-modifiers-for "japanese report done" (acons :japanese-done t nil) thought)
  (verify-modifiers-for "yes" nil thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (build-event :event "cron study japanese"))
  (verify-modifiers-for "yes" (acons :japanese-done t nil) thought)
  (verify-modifiers-for-2 '(:event "cron study japanese")
			  (acons :japanese-request nil nil) thought)
  (verify-modifiers-for "yes" nil thought))

(let ((thought (make-instance 'japanese-reminder)))
  (react thought (build-event :event "cron study japanese"))
  (verify-modifiers-for "no" (acons :japanese-done nil nil) thought)
  (verify-modifiers-for-2 '(:event "cron study japanese")
			  (acons :japanese-request t nil) thought))

(verify-messages-for (acons :japanese-done t nil) '("good"))
(verify-messages-for nil nil)
(verify-messages-for (acons :japanese-request nil nil) nil)
(verify-messages-for (acons :japanese-request t nil) '("japanese status request"))
(verify-messages-for (acons :japanese-done nil nil) '("bad"))
(verify-messages-for (acons :japanese-request '("anki") nil) '("japanese status request anki"))

(finalize)
