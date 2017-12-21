(load "package.lisp")
(load "state.lisp")
(load "event.lisp")
(load "utils.lisp")

(in-package #:com.aragaer.pa-brain)

(defclass dont-understand (thought)
  ((name :initform :dont-understand)))

(defmethod react ((thought dont-understand) event)
  (if (starts-with-p (getf event :intent) "unintelligible")
      (let ((what (string-trim " " (subseq (getf event :intent) (length "unintelligible")))))
	(add-modifier event :dont-understand (or (string= "" what) what)))))

(defmethod process ((thought dont-understand) event)
  (if (get-modifier event :dont-understand)
      (setf (getf event :response)
	    (append (getf event :response) '("failed to parse")))))

(conspack:defencoding dont-understand
		      name)
