(load "package.lisp")
(load "connect.lisp")
(load "utils.lisp")

(in-package :com.aragaer.pa-brain)

(defun my-command-line ()
  (or
   #+CLISP *args*
   #+SBCL sb-ext:*posix-argv*
   #+LISPWORKS system:*line-arguments-list*
   #+CMU extensions:*command-line-words*
   nil))

(defvar *argv* (my-command-line))
(defvar *config* nil)
(defvar *saved-file* nil)
(defvar *translator-socket-path* "/tmp/tr_socket")

(defmacro with-arg (key &rest body)
  `(let* ((pos (position ,key *argv* :test 'string-equal))
	  (value (if pos (elt *argv* (+ pos 1)))))
     (when value ,@body)))

(defun process-config ()
  (with-arg "--socket" (setf *brain-socket-path* value))
  (with-arg "--config" (setf *config* (yaml:parse (uiop:read-file-string value))))
  (with-arg "--saved" (setf *saved-file* value))
  (with-arg "--translator" (setf *translator-socket-path* value))

  (when *config*
    (aif (gethash "modules" *config*)
	 (loop for module in it
	       do (format t "; Loading \"~a\"~%" module)
	       do (load (format nil "~a.lisp" module))))))

(defun get-telegram-id ()
  (gethash "telegram" *config*))
