(load "socket.lisp")
(in-package #:com.aragaer.pa-brain)

(defvar *translator-io* nil)
(defvar *translator-addr* nil)

(defun translator-connect ()
  (setf *translator-io* (create-socket-stream *translator-addr*)))

(defun translator-send (plist)
  (handler-case (progn (json:encode-json-plist plist *translator-io*)
                       (format *translator-io* "~%"))
    #+sbcl
    (sb-int:simple-stream-error (se)
      (translator-connect)
      (translator-send plist))))

(defun translate (message key result-key)
  (handler-case (progn (translator-send (list key message))
                       (cdr (assoc result-key (json:decode-json *translator-io*))))
    (end-of-file (se)
      (translator-connect)
      (translate message key result-key))))

(defun translate-pa2human (message)
  (translate message :intent :text))

(defun translate-human2pa (message)
  (translate message :text :intent))

