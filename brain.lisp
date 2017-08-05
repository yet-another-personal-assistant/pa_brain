(load "package.lisp")

(load "translate.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *keep-going* t)
(defvar *top-level-commands* ())

(defun unknown-command (command)
  (if (> (length command) 0)
      (translate-pa2human (format nil "unknown command \"~a\"" command))))

(defmacro just-reply (reply)
  `#'(lambda (arg) (translate-pa2human ,reply)))

(defun maki-uchi-log (arg)
  (format nil "log ~a maki-uchi" arg))

(defun maki-uchi-status (arg)
  (format nil "maki-uchi status" arg))

(defun maki-uchi (arg)
  (process arg (list (cons "status" 'maki-uchi-status)
		     (cons "log" 'maki-uchi-log))))


(defun add-top-level-command (command handler)
  (setf *top-level-commands* (cons (cons command handler) *top-level-commands*)))

(add-top-level-command "hello" (just-reply "hello"))
(add-top-level-command "goodbye" (just-reply "goodbye"))
(add-top-level-command "unintelligible" (just-reply "failed to parse"))
(add-top-level-command "maki-uchi" 'maki-uchi)

(defun starts-with-p (string1 string2)
  (string= string1 string2 :end1 (min (length string1) (length string2))))

(defun process (command commands)
  (let ((entry (assoc command commands :test 'starts-with-p)))
    (if entry
	(funcall (cdr entry) (string-trim " " (subseq command (length (car entry)))))
      (unknown-command command))))

(defun main-loop ()
  (loop while *keep-going*
	do (let ((message (process (read-line *query-io*) *top-level-commands*)))
	     (if message
		 (format t "~a~%" message)))))
