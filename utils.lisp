(in-package #:com.aragaer.pa-brain)

(defun starts-with-p (string1 string2)
  (string= string1 string2 :end1 (min (length string1) (length string2))))

(defmacro aif (test-form then-form &optional else-form)
  `(let ((it ,test-form))
     (if it ,then-form ,else-form)))

(defun print-hash (stream table)
  (format stream "#HASH{~{~{([~a] : [~a])~}~^ ~}}"
          (loop for key being the hash-keys of table
                using (hash-value value)
                collect (list key value))))

(defun show-value (key hash-table)
  (multiple-value-bind (value present) (gethash key hash-table)
    (if present
      (format t "Value ~a actually present.~%" value)
      (format t "Value ~a because key not found.~%" value))))
