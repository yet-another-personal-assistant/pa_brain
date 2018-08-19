#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(format t "~a~%"
 "{\"text\": \"pong\", \"from\": {\"user\": \"niege\", \"channel\": \"brain\"}, \"to\": {\"user\": \"user\", \"channel\": \"channel\"}}")
