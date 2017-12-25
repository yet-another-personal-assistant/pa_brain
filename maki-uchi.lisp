(load "package.lisp")
(require :uiop)

(in-package #:com.aragaer.pa-brain)
(load "commands.lisp")
(load "config.lisp")

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

(defun maki-uchi (arg)
  (process-command arg (list (cons "status" 'maki-uchi-status)
			     (cons "log" 'maki-uchi-log))))

(add-top-level-command "maki-uchi" 'maki-uchi)
