(load "package.lisp")
(load "state.lisp")
(load "event.lisp")
(load "utils.lisp")
(load "translate.lisp")

(in-package #:com.aragaer.pa-brain)

(defclass admin-thought (thought)
  ((name :initform :admin)))

(defmethod react ((thought admin-thought) event)
  (if (string= (getf event :intent) "reload phrases")
      (add-response event (translator-refresh))))

(defmethod process ((thought admin-thought) event)
  )

(conspack:defencoding admin-thought
		      name)
