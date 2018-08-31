(in-package #:com.aragaer.pa-brain)

(defun create-socket-stream (socket-path)
  #+rawsock
  (rawsock:open-unix-socket-stream socket-path :direction :io)
  #+sbcl
  (let ((socket (make-instance 'sb-bsd-sockets:local-socket :type :stream)))
    (sb-bsd-sockets:socket-connect socket socket-path)
    (sb-bsd-sockets:socket-make-stream socket :input t :output t :buffering :line))
  #-(or rawsock sbcl)
  (error "not implemented"))
