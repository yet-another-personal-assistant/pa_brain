(load "package.lisp")

(load "translate.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *keep-going* t)

(defun make-command-case (command-var len-var)
  (lambda (one-case)
    (let* ((command-string (first one-case))
	   (handler (second one-case))
	   (command-len (length command-string))
	   (arg-name (gensym)))
      `((string= ,command-var ,command-string :end1 (min ,len-var ,command-len))
	(let ((,arg-name (subseq ,command-var (min ,len-var ,command-len))))
	  (funcall ,handler (string-trim " " ,arg-name)))))))

(defmacro command-case (cmd &rest cases)
  (let ((command-var (gensym))
	(len-var (gensym)))
    `(let ((,command-var ,cmd)
	   (,len-var (length ,cmd)))
       (cond ,@(mapcar (make-command-case command-var len-var) cases)))))

(defun unknown-command (command)
  (if (> (length command) 0)
      (translate-pa2human (format nil "unknown command \"~a\"" command))))

(defmacro just-reply (reply)
  `#'(lambda (arg) (translate-pa2human ,reply)))

(defun maki-uchi-log (arg)
  (format nil "log ~a maki-uchi" arg))

(defun maki-uchi (arg)
  (command-case arg
		("status" (just-reply "maki-uchi status"))
		("log" 'maki-uchi-log)))

(defun process (command)
  (command-case command
		("hello" (just-reply "hello"))
		("goodbye" (just-reply "goodbye"))
		("unintelligible" (just-reply "failed to parse"))
		("maki-uchi" 'maki-uchi)
		("" 'unknown-command)))

(defun main-loop ()
  (loop while *keep-going*
	do (let ((message (process (read-line *query-io*))))
	     (if message
		 (format t "~a~%" message)))))
