(defvar *keep-going* t)

(defun make-command-case (one-case)
  (let* ((command-string (first one-case))
	 (handler (second one-case))
	 (command-len (length command-string)))
  `((string= command ,command-string :end1 (min len ,command-len))
    (funcall ,handler (string-trim " " (subseq command (min len ,command-len)))))))

(defmacro command-case (command &rest cases)
  `(let ((len (length ,command)))
     (cond ,@(mapcar 'make-command-case cases))))

(defun unknown-command (command)
  (format nil "unknown command \"~a\"" command))

(defmacro just-reply (reply)
  `#'(lambda (arg) ,reply)) 

(defun maki-uchi-log (arg)
  (format nil "log ~a of maki-uchi" arg))

(defun process (command)
  (command-case command
		("hello" (just-reply "hello"))
		("goodbye" (just-reply "goodbye"))
		("unintelligible" (just-reply "failed to parse"))
		("maki-uchi log" 'maki-uchi-log)
		("" 'unknown-command)))

(defun main-loop ()
  (loop while *keep-going*
	do (format t "~a~%" (process (read-line *query-io*)))))

(main-loop)
