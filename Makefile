all:
	@echo "Only make test is supported for now"

test:
	sbcl --script test.lisp

.PHONY: all test
