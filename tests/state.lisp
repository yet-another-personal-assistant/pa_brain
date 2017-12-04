(in-package :cl-user)
(load #P"state.lisp")
(load #P"event.lisp")

(defpackage state-test
  (:use :cl
	:prove
	:com.aragaer.pa-brain))

(in-package #:state-test)
(load #P"test-utils.lisp")

(plan nil)
(subtest "Add thought"
	 (add-thought (make-instance 'test-thought
				     :messages '("yo")
				     :triggers '("test" "ping")))
	 (add-thought (make-instance 'test-thought
				     :messages '("hi" "there")
				     :triggers '("ping")))
	 (let ((event1 (make-event-from-intent "test"))
	       (event2 (make-event-from-intent "ping"))
	       (event3 (make-event-from-intent "hi")))
	   (try-handle event1)
	   (try-handle event2)
	   (try-handle event3)
	   (is (getf event1 :response) '("yo"))
	   (is (getf event2 :response) '("hi" "there" "yo"))
	   (is (getf event3 :response) nil)))

(finalize)
