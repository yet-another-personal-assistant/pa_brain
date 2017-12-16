(load "package.lisp")
(load "state.lisp")
(load "event.lisp")

(in-package #:com.aragaer.pa-brain)

(defclass dont-understand (thought)
  ((name :initform :dont-understand)))

(defmethod react ((thought dont-understand) event)
  (if (string-equal (getf event :intent) "unintelligible")
      (add-modifier event :dont-understand)))

(defmethod process ((thought dont-understand) event)
  (if (get-modifier event :dont-understand)
      (setf (getf event :response)
	    (append (getf event :response) '("failed to parse")))))

(conspack:defencoding dont-understand
		      name)
