all:
	echo "umm"

test:
	sbcl --noinform --load test.lisp --quit

brain.manifest: FORCE
	sbcl --noinform --load run.lisp \
		--eval '(ql:write-asdf-manifest-file "brain.manifest")' \
		--quit

.PHONY: all test FORCE
