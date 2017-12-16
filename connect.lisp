(load "package.lisp")
(load "socket.lisp")

(in-package :com.aragaer.pa-brain)

(defvar *brain-socket-path* "/tmp/pa_brain")
(defvar *brain-socket* nil)
(defvar *brain-io* nil)

(defun brain-accept ()
  (when *brain-socket-path*
    (exit-hooks:add-exit-hook #'(lambda ()
				  (if (probe-file *brain-socket-path*)
				      (delete-file *brain-socket-path*))))
    (if (not *brain-socket*)
	(setf *brain-socket* (create-server-socket *brain-socket-path*)))
    (setq *brain-io* (accept-socket-stream *brain-socket*))))
