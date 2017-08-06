(load "socket.lisp")
(load "utils.lisp")

(in-package #:com.aragaer.pa-brain)

(defvar *telegram-socket-path* "/tmp/pa_socket")
(defvar *telegram-message-prefix* "message:")
(defvar *telegram-stream* nil)

(shadowing-import (list 'trivial-gray-streams:fundamental-character-input-stream
			'trivial-gray-streams:fundamental-character-output-stream
			'trivial-gray-streams:stream-read-char
			'trivial-gray-streams:stream-write-char))

(defun make-telegram-stream (&optional message)
  (unless *telegram-stream*
    (setf *telegram-stream* (create-socket-stream *telegram-socket-path*)))
  (when message
    (format *telegram-stream* "~a~%" message))
  *telegram-stream*)

(defclass telegram-output-stream (fundamental-character-output-stream)
  ((internal-stream :initform (make-telegram-stream))
   (buffer :initform (make-string-output-stream))))

(defmethod stream-write-char ((stream telegram-output-stream) character)
  (with-slots (internal-stream buffer) stream
    (write-char character buffer)
    (when (eql character #\Newline)
      (format internal-stream "~a~a"
	      *telegram-message-prefix*
	      (get-output-stream-string buffer))
      (clear-output buffer))))

(defclass telegram-input-stream (fundamental-character-input-stream)
  ((internal-stream :initform (make-telegram-stream "register backend"))
   (buffer :initform (make-string-input-stream ""))))

(defun convert-input (new-string)
  (when (starts-with-p new-string *telegram-message-prefix*)
    (string-trim " " (subseq new-string (length *telegram-message-prefix*)))))

(defmethod stream-read-char ((stream telegram-input-stream))
  (with-slots (internal-stream buffer) stream
    (loop until (listen buffer)
	  do (let ((new-buffer (convert-input (read-line internal-stream))))
	       (when new-buffer
		 (setf buffer (make-string-input-stream (format nil "~a~%" new-buffer))))))
    (read-char buffer)))
