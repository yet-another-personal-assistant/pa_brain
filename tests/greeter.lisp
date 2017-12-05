(in-package :cl-user)

(load #P"greeter.lisp")
(defpackage greeter-test
  (:use :cl
	:prove
	:cl-mock
	:com.aragaer.pa-brain))

(in-package #:greeter-test)
(load #P"test-utils.lisp")

(plan nil)
(subtest "Greeter triggers"
	 (let ((event1 (make-event-from-intent "hello"))
	       (event2 (make-event-from-intent "goodbye")))
	   (react (make-instance 'greeter) event1)
	   (react (make-instance 'greeter) event2)
	   (is (getf event1 :modifiers) (acons :hello t nil))
	   (is (getf event2 :modifiers) (acons :hello t nil))))

(subtest "Greeter react"
	 (let ((a-greeter (make-instance 'greeter))
	       (event1 (make-event-from-intent "hello"))
	       (event2 (make-event-from-intent "hello")))
	   (react a-greeter event1)
	   (react a-greeter event2)
	   (is (getf event1 :modifiers) (acons :hello t nil))
	   (is (getf event2 :modifiers) (acons :seen-already t nil))))

(subtest "Greeter react 2"
	 (let ((a-greeter (make-instance 'greeter))
	       (event1 (make-event-from-intent "goodbye"))
	       (event2 (make-event-from-intent "goodbye")))
	   (react a-greeter event1)
	   (react a-greeter event2)
	   (is (getf event1 :modifiers) (acons :hello t nil))
	   (is (getf event2 :modifiers) nil)))

(subtest "Greeter process"
	 (let ((a-greeter (make-instance 'greeter))
	       (event1 (make-event-from-intent "goodbye"))
	       (event2 (make-event-from-intent "goodbye"))
	       (event3 (make-event-from-intent "goodbye")))
	   (setf (getf event1 :modifiers) (acons :hello t nil))
	   (setf (getf event2 :modifiers) (acons :seen-already t nil))
	   (process a-greeter event1)
	   (process a-greeter event2)
	   (is (getf event1 :response) '("hello"))
	   (is (getf event2 :response) '("seen already"))
	   (is (getf event3 :response) nil)))

(subtest "Greeter process 2"
	 (let ((a-greeter (make-instance 'greeter))
	       (event1 (make-event-from-intent "goodbye"))
	       (event2 (make-event-from-intent "goodbye"))
	       (event3 (make-event-from-intent "goodbye")))
	   (setf (getf event1 :modifiers) (acons :hello t nil))
	   (setf (getf event2 :modifiers) (acons :seen-already t nil))
	   (setf (getf event1 :response) '("yo"))
	   (setf (getf event2 :response) '("yo"))
	   (setf (getf event3 :response) '("yo"))
	   (process a-greeter event1)
	   (process a-greeter event2)
	   (is (getf event1 :response) '("hello" "yo"))
	   (is (getf event2 :response) '("seen already" "yo"))
	   (is (getf event3 :response) '("yo"))))

(defmacro with-unlock (&rest body)
  #+sbcl
  `(sb-ext:with-unlocked-packages ("COMMON-LISP") ,@body)
  #-sbcl
  `(progn ,@body))

(subtest "Greeter timeout"
	 (let ((a-greeter (make-instance 'greeter))
	       (event1 (make-event-from-intent "hello"))
	       (event2 (make-event-from-intent "hello"))
	       (event3 (make-event-from-intent "hello"))
	       (this-time (get-universal-time)))
	   (with-unlock
	    (dflet ((get-universal-time () this-time))
		   (react a-greeter event1))
	    (dflet ((get-universal-time () (+ this-time (* 5 60))))
		   (react a-greeter event2))
	    (dflet ((get-universal-time () (+ this-time (* 21 60 60))))
		   (react a-greeter event3)))
	   (is (getf event1 :modifiers) (acons :hello t nil))
	   (is (getf event2 :modifiers) (acons :seen-already t nil))
	   (is (getf event3 :modifiers) (acons :hello t nil))))

(subtest "Greeter persistence"
	 (let ((a-greeter (make-instance 'greeter))
	       (event1 (make-event-from-intent "hello"))
	       (event2 (make-event-from-intent "hello"))
	       (event3 (make-event-from-intent "hello"))
	       (this-time (get-universal-time)))
	   (with-unlock
	    (dflet ((get-universal-time () this-time))
		   (react a-greeter event1))
	    (let ((serialized (conspack:encode a-greeter)))
	      (setf a-greeter (conspack:decode serialized)))
	    (dflet ((get-universal-time () (+ this-time (* 5 60))))
		   (react a-greeter event2))
	    (dflet ((get-universal-time () (+ this-time (* 21 60 60))))
		   (react a-greeter event3)))
	   (is (getf event1 :modifiers) (acons :hello t nil))
	   (is (getf event2 :modifiers) (acons :seen-already t nil))
	   (is (getf event3 :modifiers) (acons :hello t nil))))

(finalize)
