(load "package.lisp")
(load "state.lisp")

(in-package #:com.aragaer.pa-brain)

(defclass greeter (handler)
  ((seen :initform nil)))

(defmethod handles-p ((handler greeter) trigger)
  (string-equal trigger "hello"))

(defmethod handle ((handler greeter) message)
  (with-slots (seen) handler
    (let ((result (if seen "seen already" "hello")))
      (setq seen t)
      result)))

(defmethod reset ((handler greeter))
  (with-slots (seen) handler
    (setq seen nil)))
