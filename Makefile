all:
	echo "umm"

test:
	sbcl --load test.lisp --eval '(quit)'

.PHONY: all test
