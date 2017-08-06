(load "socket.lisp")
(load "commands.lisp")
(in-package #:com.aragaer.pa-brain)

(defvar *translator-socket-path* "/tmp/tr_socket")
(defvar *translator-io* nil)

(defun translator-connect (&optional (socket-path *translator-socket-path*))
  (setf *translator-io* (create-socket-stream socket-path)))

(defun translate (message user bot)
  (handler-case
   (progn
     (json:encode-json-plist
      (list :user user :bot bot :text message)
      *translator-io*)
     (format *translator-io* "~%")
     (cdr (assoc ':reply (json:decode-json *translator-io*))))
   #+sbcl
   (sb-int:simple-stream-error () (progn
				    (translator-connect)
				    (translate message user bot)))))

(defun translate-pa2human (message)
  (translate message "pa" "pa2human"))

(defun translate-human2pa (message &optional (user "user"))
  (translate message user "human2pa"))

(defun translator-refresh (arg)
  (progn
    (json:encode-json-plist (list :command "refresh") *translator-io*)
    (format *translator-io* "~%")
    (translate-pa2human "done")))

(add-top-level-command "reload phrases" 'translator-refresh)