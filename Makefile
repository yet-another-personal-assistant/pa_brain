all:
	@echo "umm"

run:
	@sbcl --script run.lisp --non-interactive

test:
	sbcl --script test.lisp --non-interactive
