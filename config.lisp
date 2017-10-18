(load "package.lisp")
(load "connect.lisp")
(load "brain.lisp")

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

(defmacro with-arg (key &rest body)
  `(let* ((pos (position ,key *argv* :test 'string-equal))
	  (value (if pos (elt *argv* (+ pos 1)))))
     (when value ,@body)))

(defun process-config ()
  (progn
    (with-arg "--socket" (setf *brain-socket-path* value))
    (with-arg "--config" (setf *config* (yaml:parse (uiop:read-file-string value))))
    (with-arg "--tg-owner" (setf *tg-owner* value)) ; TODO: drop this parameter

    (when *config*
      (setf *tg-owner* (gethash "telegram" *config*))
      (aif (gethash "modules" *config*)
	   (loop for module in it
		 do (format t "; Loading \"~a\"~%" module)
		 do (load (format nil "~a.lisp" module)))))))
