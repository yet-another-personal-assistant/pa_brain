(load "package.lisp")
(load "state.lisp")
(load "event.lisp")

(in-package #:com.aragaer.pa-brain)

(defparameter *reminder-reset* (* 24 60 60))

(defclass japanese-reminder (thought)
  ((name :initform :japanese-reminder)
   (done :initform 0)
   (status-requested :initform nil)))

(defmethod react ((thought japanese-reminder) event)
  (with-slots (done status-requested) thought
    (cond ((string-equal (getf event :intent) "japanese report done")
	   (setf done (get-universal-time))
	   (setf status-requested nil)
	   (add-modifier event :japanese-done))
	  ((string-equal (getf event :intent) "cron study japanese")
	   (add-modifier event :japanese-request
			 (>= (- (get-universal-time) done) *reminder-reset*))
	   (setf status-requested t))
	  ((and (string-equal (getf event :intent) "yes")
		status-requested)
	   (setf done (get-universal-time))
	   (add-modifier event :japanese-done)
	   (setf status-requested nil))
	  ((and (string-equal (getf event :intent) "no")
		status-requested)
	   (add-modifier event :japanese-done nil)
	   (setf status-requested nil)))))


(defmethod process ((thought japanese-reminder) event)
  (cond ((get-modifier event :japanese-done)
	 (setf (getf event :response) (push "good" (getf event :response))))
	((get-modifier event :japanese-request)
	 (setf (getf event :response) (push "japanese status request" (getf event :response))))
	((assoc :japanese-done (getf event :modifiers))
	 (setf (getf event :response) (push "bad" (getf event :response))))))

(conspack:defencoding japanese-reminder
		      name done status-requested)
