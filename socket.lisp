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

(defun create-server-socket (socket-path)
  #+sbcl
  (let ((socket (make-instance 'sb-bsd-sockets:local-socket :type :stream)))
    (when (probe-file socket-path)
      (delete-file socket-path))
    (sb-bsd-sockets:socket-bind socket socket-path)
    (sb-bsd-sockets:socket-listen socket 0)
    socket)
  #-sbcl
  (error "not implemented"))

(defun accept-socket-stream (socket)
  #+sbcl
  (let ((remote (sb-bsd-sockets:socket-accept socket)))
    (sb-bsd-sockets:socket-make-stream remote :input t :output t :buffering :line))
  #-sbcl
  (error "not implemented"))
