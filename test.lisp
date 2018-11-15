#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(with-open-file (*standard-output* "/dev/null"
				   :direction :output
				   :if-exists :supersede)
		(ql:quickload :prove))

(ql:quickload :cl-json :silent t)

(setf prove:*enable-colors* nil)

(if (and
     (prove:run #P"tests/active_channel.lisp" :reporter :list)
     (prove:run #P"tests/active_user.lisp" :reporter :list)
     (prove:run #P"tests/commands.lisp" :reporter :list)
     (prove:run #P"tests/dont_understand.lisp" :reporter :list)
     (prove:run #P"tests/good_morning.lisp" :reporter :list)
     (prove:run #P"tests/handle_message.lisp" :reporter :list)
     (prove:run #P"tests/hello.lisp" :reporter :list))
    (format t "PASSED~%")
  (format t "FAILED~%"))
