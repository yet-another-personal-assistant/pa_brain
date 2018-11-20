(load "package.lisp")
(load "translate.lisp")
(load "utils.lisp")

(in-package :com.aragaer.pa-brain)

(defun react (intent)
  (cond ((string= intent "hello")
         "hello")
        (t
         "dont-understand")))

(defvar *active-user* nil)
(defvar *queued* nil)
(defvar *active-channel* nil)

(defun set-user (user)
  (setf *active-user* user
        *queued* nil
        *active-channel* nil))

(defvar *human2pa* 'identity)
(defvar *pa2human* 'identity)

(defun handle-command (message)
  (switch ((assoc-value :command message) :test 'string=)
          ("switch-user"
           (setf *active-user* (assoc-value :user message))
           nil)
          ("say"
           `(((:message . ,(assoc-value :text message)))))))

(defun handle-event-new-day (message)
  '(((:intent . "good morning"))))

(defun handle-event-presence (message)
  (setf *active-channel* (traverse-a-list message :from :channel))
  nil)

(defun handle-event-gone (message)
  (if (string= *active-channel* (traverse-a-list message :from :channel))
      (setf *active-channel* nil)))

(defun handle-event (message)
  (funcall
   (switch ((assoc-value :event message) :test 'string=)
           ("new-day" 'handle-event-new-day)
           ("presence" 'handle-event-presence)
           ("gone" 'handle-event-gone))
   message))

(defun handle-user-message (message)
  (let* ((from (assoc-value :from message))
         (intent (funcall *human2pa* (assoc-value :message message))))
    (list (acons :intent (react intent)
                 (if from (acons :to from nil))))))

(defun translate-to-human (message)
  (when-let (intent (assoc :intent message))
    (rplaca intent :message)
    (rplacd intent (funcall *pa2human* (cdr intent))))
  message)

(defun add-source (message)
  (add-or-create message :from '((:user . "niege")
                                 (:channel . "brain"))))

(defun add-dest (message)
  (add-or-create message :to `((:user . ,*active-user*)
                               (:channel . ,*active-channel*))))

(defun correct-user-p (message)
  (string= *active-user*
           (traverse-a-list message :from :user)))

(defun handle-message (message)
  (let ((new (cond
               ((assoc :command message) (handle-command message))
               ((not (correct-user-p message)) nil)
               ((assoc :event message) (handle-event message))
               (t (handle-user-message message)))))
    (mapcar (compose 'add-source 'add-dest 'translate-to-human)
            (loop for msg in (append *queued* new)
               if (or *active-channel* (assoc :to msg)) collect msg
               else collect msg into keep
               finally (setf *queued* keep)))))
