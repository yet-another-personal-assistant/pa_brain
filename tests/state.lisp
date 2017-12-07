(in-package :cl-user)
(load #P"state.lisp")
(load #P"event.lisp")
(load #P"greeter.lisp")

(defpackage state-test
  (:use :cl
	:prove
	:conspack
	:com.aragaer.pa-brain))

(in-package #:state-test)
(load #P"test-utils.lisp")

(plan nil)
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
  (is (getf event3 :response) nil))

(defvar *x* nil)

(format t "no default, empty saved~%")
(uiop/stream:with-temporary-file (:stream s
					  :direction :io
					  :prefix "THT"
					  :element-type 'unsigned-byte)
				 (encode nil :stream s)
				 (file-position s 0)
				 (load-state s))
(let ((event1 (make-event-from-intent "hello")))
  (try-handle event1)
  (is (getf event1 :response) nil))

(format t "no default, saved greeter~%")
(let ((event1 (make-event-from-intent "hello"))
      (event2 (make-event-from-intent "hello"))
      (event3 (make-event-from-intent "hello"))
      (a-greeter (make-instance 'greeter)))
  (uiop/stream:with-temporary-file (:stream s
					    :direction :io
					    :prefix "THT"
					    :element-type 'unsigned-byte)
				   (encode nil :stream s)
				   (file-position s 0)
				   (load-state s)
				   (add-thought (make-instance 'greeter))
				   (try-handle (make-event-from-intent "hello"))
				   (file-position s 0)
				   (save-state s)
				   (file-position s 0)
				   (load-state s))
  (react a-greeter event3)
  (process a-greeter event3)

  (try-handle event1)
  (react a-greeter event2)
  (process a-greeter event2)
  (is (getf event1 :response) (getf event2 :response)))

(format t "default greeter, saved empty~%")
(add-default-thought :greeter #'(lambda () (make-instance 'greeter)))
(uiop/stream:with-temporary-file (:stream s
					  :direction :io
					  :prefix "THT"
					  :element-type 'unsigned-byte)
				 (encode nil :stream s)
				 (file-position s 0)
				 (load-state s))
(let ((event1 (make-event-from-intent "hello"))
      (event2 (make-event-from-intent "hello"))
      (a-greeter (make-instance 'greeter)))
  (try-handle event1)
  (react a-greeter event2)
  (process a-greeter event2)
  (is (getf event1 :response) (getf event2 :response)))

(format t "default greeter, saved greeter~%")
(let ((event1 (make-event-from-intent "hello"))
      (event2 (make-event-from-intent "hello"))
      (event3 (make-event-from-intent "hello"))
      (a-greeter (make-instance 'greeter)))
  (uiop/stream:with-temporary-file (:stream s
					    :direction :io
					    :prefix "THT"
					    :element-type 'unsigned-byte)
				   (encode nil :stream s)
				   (file-position s 0)
				   (load-state s)
				   (try-handle (make-event-from-intent "hello"))
				   (file-position s 0)
				   (save-state s)
				   (file-position s 0)
				   (load-state s))
  (react a-greeter event3)
  (process a-greeter event3)

  (try-handle event1)
  (react a-greeter event2)
  (process a-greeter event2)
  (is (getf event1 :response) (getf event2 :response)))

(finalize)
