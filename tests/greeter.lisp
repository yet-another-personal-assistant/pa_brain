(in-package :cl-user)

(load #P"greeter.lisp")

(in-package #:com.aragaer.pa-brain)
(use-package :prove)

(defvar *greeter* (make-instance 'greeter))

(plan nil)
(subtest "Greeter triggers"
	 (ok (handles-p *greeter* "hello"))
	 (ok (not (handles-p *greeter* "goodbye"))))

(subtest "Greeter toggle"
	 (is (handle *greeter* "hello") "hello" :test #'string-equal)
	 (is (handle *greeter* "hello") "seen already" :test #'string-equal)
	 (reset *greeter*)
	 (is (handle *greeter* "hello") "hello" :test #'string-equal))

(finalize)
