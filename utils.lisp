(in-package #:com.aragaer.pa-brain)

(defun starts-with-p (string1 string2)
  (string= string1 string2 :end1 (min (length string1) (length string2))))
