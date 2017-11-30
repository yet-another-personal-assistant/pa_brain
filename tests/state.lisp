(in-package :cl-user)

(load #P"state.lisp")

(in-package #:com.aragaer.pa-brain)
(use-package :prove)

(defclass my-handler (handler)
  ((messages :initarg :messages)
   (triggers :initarg :triggers)))

(defmethod handles-p ((handler my-handler) trigger)
  (member trigger (slot-value handler 'triggers) :test 'string-equal))

(defvar *calls* (list))

(defmethod handle ((handler my-handler) message)
  (push message *calls*)
  (slot-value handler 'messages))

(plan nil)
(subtest "Add handler"
	 (add-handler (make-instance 'my-handler
				     :messages "yo"
				     :triggers '("test" "ping")))
	 (add-handler (make-instance 'my-handler
				     :messages '("hi" "there")
				     :triggers '("ping")))
	 (is (try-handle "test") '("yo"))
	 (is (try-handle "ping") '("hi" "there" "yo"))
	 (ok (not (try-handle "hi"))))

(finalize)
