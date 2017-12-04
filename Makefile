all:
	echo "umm"

test:
	sbcl --noinform --load test.lisp --eval '(quit)'

.PHONY: all test
