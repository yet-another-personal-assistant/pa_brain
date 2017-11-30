#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :prove)

(prove:run #P"tests/state.lisp" :reporter :list)
(prove:run #P"tests/greeter.lisp" :reporter :list)
