#-clisp
(error "Not implemented")

(in-package #:com.aragaer.pa-brain)

(defvar *translator-socket-path* "/tmp/tr_socket")
(defvar *translator-io* nil)

(defun translator-connect (&optional (socket-path *translator-socket-path*))
  (setf *translator-io*
	(rawsock:open-unix-socket-stream
	 socket-path :direction :io)))

(defun translate (message user bot)
  (progn
    (json:encode-json-plist
     (list :user user :bot bot :text message)
     *translator-io*)
    (format *translator-io* "~%")
    (cdr (assoc ':reply (json:decode-json *translator-io*)))))

(defun translate-pa2human (message)
  (translate message "pa" "pa2human"))

(defun translate-human2pa (message (user "user"))
  (translate message user "human2pa"))
