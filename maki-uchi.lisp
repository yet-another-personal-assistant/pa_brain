(load "package.lisp")
(require :uiop)

(in-package #:com.aragaer.pa-brain)
(load "commands.lisp")
(load "config.lisp")

(defvar *maki-uchi-binary*
  (namestring (merge-pathnames "Projects/maki-uchi/maki-uchi" (user-homedir-pathname))))
(defvar *maki-uchi-log-file* nil)

(defun maki-uchi-translate-one (message)
  (translate-pa2human (format nil "makiuchi ~a" message)))

(defun maki-uchi-translate (messages)
  (mapcar 'maki-uchi-translate-one messages))

(defun get-maki-uchi-status-lines ()
  (uiop:run-program
   (list *maki-uchi-binary* "-f" *maki-uchi-log-file* "-p")
   :output :lines))

(defun maki-uchi-status (arg)
  (maki-uchi-translate (get-maki-uchi-status-lines)))

(defun maki-uchi-log (arg)
  (progn
    (uiop:run-program
     (list *maki-uchi-binary* "-f" *maki-uchi-log-file* arg))
    (append (list (translate-pa2human "good"))
	    (maki-uchi-translate (get-maki-uchi-status-lines)))))

(defun maki-uchi (arg)
  (process arg (list (cons "status" 'maki-uchi-status)
		     (cons "log" 'maki-uchi-log))))

(add-top-level-command "maki-uchi" 'maki-uchi)

(if *config* (setf *maki-uchi-log-file* (gethash "maki-uchi" *config*)))
