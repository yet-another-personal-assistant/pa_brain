(load "package.lisp")
(load "state.lisp")
(load "event.lisp")

(in-package #:com.aragaer.pa-brain)

(defparameter *reminder-reset* (* 24 60 60))
(defparameter *tasks* '("anki" "duolingo"))

(defclass japanese-reminder (thought)
  ((name :initform :japanese-reminder)
   (tasks :initform nil)
   (done :initform 0)
   (status-requested :initform nil)))

(defun japanese-request-status (thought event)
  (with-slots (done tasks status-requested) thought
    (when (>= (- (get-universal-time) done) *reminder-reset*)
      (setf tasks nil))
    (let ((not-done (loop for task in *tasks*
			  unless (member task tasks :test 'string-equal)
			  collect task)))
      (add-modifier event :japanese-request (or (not tasks) not-done))
      (setf status-requested (not (null not-done))))))

(defun mark-as-done (thought &optional (what *tasks*))
  (with-slots (done tasks) thought
    (setf done (get-universal-time))
    (unless (listp what)
      (setf what (list what)))
    (setf tasks (append what tasks))))

(defmethod react ((thought japanese-reminder) event)
  (with-slots (done tasks status-requested) thought
    (cond ((starts-with-p (getf event :intent) "japanese report")
	   (setf status-requested nil)
	   (let ((what (string-trim " " (subseq (getf event :intent) (length "japanese report")))))
	     (mark-as-done thought (if (string-equal what "done") *tasks* what)))
	   (add-modifier event :japanese-done))
	  ((string-equal (getf event :intent) "cron study japanese")
	   (japanese-request-status thought event))
	  ((and (string-equal (getf event :intent) "yes")
		status-requested)
	   (mark-as-done thought *tasks*)
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
	 (let* ((what (get-modifier event :japanese-request))
		(msg (if (listp what)
			 (format nil "japanese status request ~{~a~^ ~}" what)
		       "japanese status request")))
	 (setf (getf event :response) (push msg (getf event :response)))))
	((assoc :japanese-done (getf event :modifiers))
	 (setf (getf event :response) (push "bad" (getf event :response))))))

(conspack:defencoding japanese-reminder
		      name tasks done status-requested)
