#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(with-open-file (*standard-output* "/dev/null" :direction :output
				   :if-exists :supersede)
		(ql:quickload :cl-mock)
		(ql:quickload :prove))

(prove:run #P"tests/state.lisp" :reporter :list)
(prove:run #P"tests/greeter.lisp" :reporter :list)
