(load "package.lisp")
(load "config.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *thoughts* nil)
(defvar *default-thoughts* nil)

(defclass thought ()
  ((name :initarg :name)
   (finished :initform nil)))

(defgeneric react (thought event))
(defgeneric process (thought event))

(defun finished-p (thought)
  (slot-value thought 'finished))

(defun mark-finished (thought &optional (value t))
  (setf (slot-value thought 'finished) value))

(defun try-handle (event)
  (loop for (prio . thought) in *thoughts*
	do (react thought event))
  (loop for (prio . thought) in *thoughts*
	do (process thought event)))

(defun add-thought (thought &key (priority 0))
  (setf *thoughts* (stable-sort (acons priority thought *thoughts*)
				#'> :key #'car)))

(defun add-default-thought (name constructor &key (priority 0))
  (setf *default-thoughts* (acons name (cons constructor priority) *default-thoughts*)))

(defun save-state (stream)
  (conspack:tracking-refs ()
			  (conspack:encode *thoughts* :stream stream)))

(defun create-defaults ()
  (let ((names (loop for (prio . thought) in *thoughts*
		     collecting (slot-value thought 'name))))
    (loop for (name . (constructor . prio)) in *default-thoughts*
	  do (unless (member name names)
	       (add-thought (funcall constructor) :priority prio)))))

(defun load-state (stream)
  (conspack:tracking-refs ()
			  (setf *thoughts* (conspack:decode-stream stream)))
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
