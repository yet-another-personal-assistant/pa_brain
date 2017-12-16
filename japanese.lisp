(load "package.lisp")
(load "state.lisp")
(load "event.lisp")
(load "dialog.lisp")

(in-package #:com.aragaer.pa-brain)

(defparameter *reminder-reset* (* 24 60 60))
(defparameter *tasks* '("anki" "duolingo"))

(defclass japanese-reminder (thought)
  ((name :initform :japanese-reminder)
   (tasks :initform nil)
   (done :initform 0)
   (status-requested :initform nil)
   (dialog :initform nil)))

(defun mark-as-done (thought &optional (what *tasks*))
  (with-slots (done tasks) thought
    (setf done (get-universal-time))
    (setf tasks (append (ensure-list what) tasks))))

(defmacro japanese-dialog-result (is-done)
  `(defun ,(intern (format nil "japanese-dialog-~a" (if is-done "yes" "no")))
       (thought event data)
       (declare (ignore data))
     ,(if is-done '(mark-as-done (slot-value thought 'link)))
     (mark-finished thought)
     (add-modifier event :japanese-done ,is-done)))

(japanese-dialog-result t)
(japanese-dialog-result nil)

(defun make-japanese-dialog (habit)
  (make-instance 'dialog
		 :name :japanese-dialog
		 :link habit
		 :triggers (acons "yes" 'japanese-dialog-yes
				  (acons "no" 'japanese-dialog-no nil))))

(defun japanese-request-status (thought event)
  (with-slots (done tasks status-requested) thought
    (when (>= (- (get-universal-time) done) *reminder-reset*)
      (setf tasks nil))
    (let ((not-done (loop for task in *tasks*
			  unless (member task tasks :test 'string-equal)
			  collect task)))
      (add-modifier event :japanese-request (or (not tasks) not-done))
      (not (null not-done)))))

(defmethod react ((thought japanese-reminder) event)
  (with-slots (dialog) thought
    (if dialog (react dialog event))
    (let ((intent (getf event :intent))
	  (need-dialog nil))
      (cond ((starts-with-p intent "japanese report")
	     (let ((what (string-trim " " (subseq intent (length "japanese report")))))
	       (mark-as-done thought (if (string-equal what "done") *tasks* what)))
	     (add-modifier event :japanese-done))
	    ((string-equal intent "cron study japanese")
	     (setf need-dialog (japanese-request-status thought event))))
      (if (and need-dialog (not dialog))
	  (setf dialog (make-japanese-dialog thought)))
      (if (and dialog (not need-dialog))
	  (setf dialog nil)))))

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
		      name tasks done status-requested dialog)
