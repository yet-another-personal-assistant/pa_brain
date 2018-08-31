(load "socket.lisp")
(in-package #:com.aragaer.pa-brain)

(defvar *translator-io* nil)

(defun translator-connect (socket-path)
  (setf *translator-io* (create-socket-stream socket-path)))

(defun translate (message key result-key)
  (json:encode-json-plist
   (list key message)
   *translator-io*)
  (format *translator-io* "~%")
  (cdr (assoc result-key (json:decode-json *translator-io*))))

(defun translate-pa2human (message)
  (translate message :intent :text))

(defun translate-human2pa (message)
  (translate message :text :intent))

