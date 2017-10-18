(load "package.lisp")
(require :uiop)

(in-package #:com.aragaer.pa-brain)
(load "commands.lisp")
(load "config.lisp")

(defvar *maki-uchi-binary*
  (namestring (merge-pathnames "Projects/maki-uchi/maki-uchi" (user-homedir-pathname))))
(defvar *maki-uchi-log-file*
  (namestring (merge-pathnames "Dropbox/maki-uchi.log" (user-homedir-pathname))))

(defun maki-uchi-translate (message)
  (translate-pa2human (format nil "makiuchi ~a" message)))

(defun get-maki-uchi-status-lines ()
  (uiop:run-program
   (list *maki-uchi-binary* "-f" *maki-uchi-log-file* "-p")
   :output :lines))

(defun maki-uchi-status (arg)
  (mapcar 'maki-uchi-translate (get-maki-uchi-status-lines)))

(defun maki-uchi-log (arg)
  (progn
    (uiop:run-program
     (list *maki-uchi-binary* "-f" *maki-uchi-log-file* arg))
    (append (list (translate-pa2human "good"))
	    (mapcar 'maki-uchi-translate (rest (get-maki-uchi-status-lines))))))

(defun maki-uchi (arg)
  (process arg (list (cons "status" 'maki-uchi-status)
		     (cons "log" 'maki-uchi-log))))

(add-top-level-command "maki-uchi" 'maki-uchi)

(if *config*
    (setf *maki-uchi-log-file* (gethash "maki-uchi" *config*)))
