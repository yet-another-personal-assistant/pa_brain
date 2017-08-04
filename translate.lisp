#-clisp
(error "Not implemented")

(in-package #:com.aragaer.pa-brain)

(defvar *translator-socket-path* "/tmp/tr_socket")
(defvar *translator-in* nil)
(defvar *translator-out* nil)
(defvar *translator-io* nil)

(defun translator-connect (&optional (socket-path *translator-socket-path*))
  (setf (values *translator-io* *translator-in* *translator-out*)
	(ext:make-pipe-io-stream
	 (concatenate 'string "socat STDIO UNIX-CONNECT:" socket-path))))

(defun translate (message user bot)
  (progn
    (json:encode-json-plist
     (list :user user :bot bot :text message)
     *translator-out*)
    (format *translator-out* "~%")
    (finish-output *translator-out*)
    (cdr (assoc ':reply (json:decode-json *translator-in*)))))

(defun translate-pa2human (message)
  (translate message "pa" "pa2human"))

(defun translate-human2pa (message (user "user"))
  (translate message user "human2pa"))
