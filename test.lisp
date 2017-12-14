#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(with-open-file (*standard-output* "/dev/null" :direction :output
				   :if-exists :supersede)
		(ql:quickload :alexandria)
		(ql:quickload :cl-conspack)
		(ql:quickload :cl-mock)
		(ql:quickload :cl-yaml)
		(ql:quickload :exit-hooks)
		(ql:quickload :prove))

(if (and
     (prove:run #P"tests/greeter.lisp" :reporter :list)
     (prove:run #P"tests/state.lisp" :reporter :list)
     (prove:run #P"tests/japanese.lisp" :reporter :list))
    (format t "PASSED~%")
  (format t "FAILED~%"))
