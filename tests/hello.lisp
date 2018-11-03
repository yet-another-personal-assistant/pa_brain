(in-package :cl-user)

(load #P"brain.lisp")

(defpackage hello-test
  (:use :cl
        :prove
        :com.aragaer.pa-brain))

(in-package #:hello-test)
(plan nil)

(is (react "hello") "hello")

(finalize)
