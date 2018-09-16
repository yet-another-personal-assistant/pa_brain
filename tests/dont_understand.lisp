(in-package :cl-user)

(load #P"brain.lisp")

(defpackage dont-understand-test
  (:use :cl
        :prove
        :com.aragaer.pa-brain))

(in-package #:dont-understand-test)
(plan nil)

(is (react "x") "dont-understand")

(finalize)
