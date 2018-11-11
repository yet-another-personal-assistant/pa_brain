(defpackage #:com.aragaer.pa-brain
  (:use #:common-lisp)
  (:import-from #:alexandria
                :compose
                :if-let
                :lastcar
                :switch
                :when-let)
  (:export :react
           :handle-message
           :set-user
           :*pa2human*
           :*human2pa*))
