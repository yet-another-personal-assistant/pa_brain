(in-package :cl-user)

(load #P"greeter.lisp")
(defpackage greeter-test
  (:use :cl
	:prove
	:com.aragaer.pa-brain))

(in-package #:greeter-test)
(load #P"test-utils.lisp")

(plan nil)
(subtest "Greeter triggers"
	 (let ((event1 (make-event-from-intent "hello"))
	       (event2 (make-event-from-intent "goodbye")))
	   (react (make-instance 'greeter) event1)
	   (react (make-instance 'greeter) event2)
	   (ok (assoc-value :hello (getf event1 :modifiers)))
	   (ok (not (assoc-value :seen-already (getf event1 :modifiers))))
	   (ok (assoc-value :hello (getf event1 :modifiers)))
	   (ok (not (assoc-value :seen-already (getf event1 :modifiers))))))

(subtest "Greeter react"
	 (let ((a-greeter (make-instance 'greeter))
	       (event1 (make-event-from-intent "hello"))
	       (event2 (make-event-from-intent "hello")))
	   (react a-greeter event1)
	   (react a-greeter event2)
	   (ok (assoc-value :hello (getf event1 :modifiers)))
	   (ok (not (assoc-value :seen-already (getf event1 :modifiers))))
	   (ok (not (assoc-value :hello (getf event2 :modifiers))))
	   (ok (assoc-value :seen-already (getf event2 :modifiers)))))

(subtest "Greeter react 2"
	 (let ((a-greeter (make-instance 'greeter))
	       (event1 (make-event-from-intent "goodbye"))
	       (event2 (make-event-from-intent "goodbye")))
	   (react a-greeter event1)
	   (react a-greeter event2)
	   (ok (assoc-value :hello (getf event1 :modifiers)))
	   (ok (not (assoc-value :seen-already (getf event1 :modifiers))))
	   (ok (not (assoc-value :hello (getf event2 :modifiers))))
	   (ok (not (assoc-value :seen-already (getf event2 :modifiers))))))

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

;(subtest "Greeter timeout"
;	 (let ((a-greeter (make-instance 'greeter))
;	       (event1 (make-event-from-intent "hello"))
;					    (this-time (get-universal-time)))
;	   (react a-greeter event1)))

(finalize)
