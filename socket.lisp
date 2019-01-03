(in-package #:com.aragaer.pa-brain)

(defun create-unix-socket-stream (socket-path)
  #+rawsock
  (rawsock:open-unix-socket-stream socket-path :direction :io)
  #+sbcl
  (let ((socket (make-instance 'sb-bsd-sockets:local-socket :type :stream)))
    (sb-bsd-sockets:socket-connect socket socket-path)
    (sb-bsd-sockets:socket-make-stream socket :input t :output t :buffering :line))
  #-(or rawsock sbcl)
  (error "not implemented"))

(defun create-tcp-socket-stream (host port)
  #+sbcl
  (let ((socket (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp))
        (addr (sb-bsd-sockets:make-inet-address host)))
    (sb-bsd-sockets:socket-connect socket addr port)
    (sb-bsd-sockets:socket-make-stream socket :input t :output t :buffering :line))
  #-sbcl
  (error "not implemented"))

(defun create-socket-stream (addr)
  (handler-case
      (if-let ((colon (position #\: addr)))
          (let ((host (subseq addr 0 colon))
                (port (parse-integer (subseq addr (+ 1 colon)))))
            (create-tcp-socket-stream host port))
        (create-unix-socket-stream addr))
    #+sbcl
    (sb-bsd-sockets:socket-error ()
      (sleep 0.1)
      (create-socket-stream addr))))
