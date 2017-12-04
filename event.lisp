(load "package.lisp")
(load "utils.lisp")

(in-package #:com.aragaer.pa-brain)

(defun make-event (intent text source)
  (list :intent intent :text text :source source
	:response nil :modifiers nil))

(defun add-modifier (event modifier &optional (value t))
  (setf (getf event :modifiers)
	(acons modifier value (getf event :modifiers))))

(defun get-modifier (event modifier)
  (aif (assoc modifier (getf event :modifiers))
       (cdr it)))

(defun add-response (event response)
  (setf (getf event :response)
	(append (getf event :response) (list response))))
