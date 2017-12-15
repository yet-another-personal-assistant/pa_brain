(load "package.lisp")
(load "config.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *thoughts* nil)
(defvar *default-thoughts* nil)

(defclass thought ()
  ((name :initarg :name)))

(defgeneric react (thought event))
(defgeneric process (thought event))

(defun try-handle (event)
  (loop for thought in *thoughts*
	do (react thought event))
  (loop for thought in *thoughts*
	do (process thought event)))

(defun add-thought (thought)
  (push thought *thoughts*))

(defun add-default-thought (name constructor)
  (setf *default-thoughts* (acons name constructor *default-thoughts*)))

(defun save-state (stream)
  (conspack:encode *thoughts* :stream stream))

(defun create-defaults ()
  (let ((names (loop for thought in *thoughts*
		     collecting (slot-value thought 'name))))
    (loop for default in *default-thoughts*
	  when (not (member (car default) names))
	  do (add-thought (funcall (cdr default))))))

(defun load-state (stream)
  (setf *thoughts* (conspack:decode-stream stream))
  (create-defaults))

(defun do-save-state ()
  (with-open-file (stream *saved-file*
			  :direction :output :if-exists :supersede
			  :element-type 'unsigned-byte)
		  (save-state stream)))

(defun init-thoughts ()
  (when *saved-file*
    (exit-hooks:add-exit-hook 'do-save-state)
    (with-open-file (stream *saved-file*
			    :direction :input
			    :if-does-not-exist nil
			    :element-type 'unsigned-byte)
		    (if stream
			(load-state stream)
		      (create-defaults)))))
