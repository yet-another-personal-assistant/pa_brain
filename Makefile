ifeq ($(LISP),)
  LISP_CMD=sbcl --script
endif

ifeq ($(LISP),sbcl)
  LISP_CMD=sbcl --script
endif

ifeq ($(LISP),clisp)
  LISP_CMD=clisp
endif

all:
	@echo "Only make test is supported for now"

test:
	$(LISP_CMD) test.lisp

.PHONY: all test
