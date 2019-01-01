(load "package.lisp")

(in-package :com.aragaer.pa-brain)

(defun assoc-value (key a-list)
  (cdr (assoc key a-list)))

(defmacro add-or-create (a-list property value)
  `(if (assoc ,property ,a-list)
       ,a-list
       (acons ,property ,value ,a-list)))

(defun traverse-a-list (a-list &rest fields)
  (reduce 'assoc-value
          (reverse fields)
          :from-end t
          :initial-value a-list))
