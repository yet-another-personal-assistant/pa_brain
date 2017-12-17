(defun event-intent-equal-p (event text)
  (string-equal (getf event :intent) text))

(defun make-event-from-intent (intent &optional modifiers)
  (let ((result (make-event intent nil nil)))
    (setf (getf result :modifiers) modifiers)
    result))

(defun make-event-from-text (text &optional modifiers)
  (let ((result (make-event text text nil)))
    (setf (getf result :modifiers) modifiers)
    result))

(defclass test-thought (thought)
  ((messages :initarg :messages)
   (triggers :initarg :triggers)))

(defmethod react ((thought test-thought) event)
  (if (member event (slot-value thought 'triggers) :test 'event-intent-equal-p)
      (setf (getf event :response)
	    (append (getf event :response) (slot-value thought 'messages)))))

(defmethod process ((thought test-thought) event))

(defun assoc-value (key alist)
  (cdr (assoc key alist)))

(conspack:defencoding test-thought
		      messages triggers)

(defmacro with-unlock (&rest body)
  #+sbcl
  `(sb-ext:with-unlocked-packages ("COMMON-LISP") ,@body)
  #-sbcl
  `(progn ,@body))

(defparameter *thought-class-under-test* nil)

(defun verify-modifiers-for (text modifiers &optional
				  (thought (if *thought-class-under-test*
					       (make-instance *thought-class-under-test*))))
  (let ((event (make-event-from-text text)))
    (react thought event)
    (is (getf event :modifiers) modifiers)))

(defun verify-messages-for (modifiers messages)
  (let ((event (make-event-from-intent "" modifiers))
	(a-thought (make-instance *thought-class-under-test*)))
    (process a-thought event)
    (is (getf event :response) messages)))
