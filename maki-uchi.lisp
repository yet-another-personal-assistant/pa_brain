(load "package.lisp")
(require :uiop)

(in-package #:com.aragaer.pa-brain)
(load "config.lisp")
(load "utils.lisp")

(defvar *maki-uchi-binary*
  (namestring (merge-pathnames "Projects/maki-uchi/maki-uchi" (user-homedir-pathname))))
(defvar *maki-uchi-log-file* nil)

(defun maki-uchi-translate (messages)
  (loop for message in messages
	collect (format nil "makiuchi ~a" message)))

(defun get-maki-uchi-status-lines ()
  (uiop:run-program
   (list *maki-uchi-binary* "-f" *maki-uchi-log-file* "-p")
   :output :lines))

(defun maki-uchi-status (arg)
  (declare (ignore arg))
  (maki-uchi-translate (get-maki-uchi-status-lines)))

(defun maki-uchi-log (arg)
  (uiop:run-program
   (list *maki-uchi-binary* "-f" *maki-uchi-log-file* arg))
  (append '("good") (maki-uchi-translate (get-maki-uchi-status-lines))))

(defclass maki-uchi-thought (thought)
  ((name :initform :maki-uchi)))

(defmethod react ((thought maki-uchi-thought) event)
  (let ((intent (getf event :intent)))
    (if (alexandria:starts-with-subseq "maki-uchi" intent)
	(let ((action (remove-prefix intent "maki-uchi")))
	  (loop for line in
		(cond ((string= "status" action)
		       (maki-uchi-status nil))
		      ((alexandria:starts-with-subseq "log" action)
		       (maki-uchi-log (remove-prefix action "log"))))
		do (add-response event line))))))

(defmethod process ((thought maki-uchi-thought) event)
  )

(conspack:defencoding maki-uchi-thought
		      name)
