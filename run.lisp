#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :cl-json)
(ql:quickload :uiop)

(load "brain.lisp")
(load "maki-uchi.lisp")
(load "cron.lisp")
(load "socket.lisp")

(in-package :com.aragaer.pa-brain)

(defun my-command-line ()
  (or
   #+CLISP *args*
   #+SBCL sb-ext:*posix-argv*
   #+LISPWORKS system:*line-arguments-list*
   #+CMU extensions:*command-line-words*
   nil))

(let* ((args (my-command-line))
       (sock-arg (position "--socket" args :test 'string-equal))
       (owner-arg (position "--tg-owner" args :test 'string-equal)))
  (if sock-arg
      (progn
	(setf *brain-socket-path* (elt args (+ sock-arg 1)))
	(close-socket *brain-socket*)
	(setf *brain-socket* (create-server-socket *brain-socket-path*))))
  (if owner-arg
      (progn
	(setf *tg-owner* (elt args (+ owner-arg 1))))))

(translator-connect)
(brain-accept)
(brain-output (translate-pa2human "ready"))
;(cl-user::quit)
(handler-case
 (main-loop)
 #+sbcl
 (sb-sys:interactive-interrupt () nil))
