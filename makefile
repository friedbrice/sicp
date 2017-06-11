all: html pdf racket

target:
	mkdir -p target

html: sicp.md target
	pandoc -t html5 --standalone --mathjax -o target/sicp.html sicp.md

pdf: sicp.md target
	pandoc -t latex -o target/sicp.pdf sicp.md

racket: sicp.md target
	$(info 'racket' target not implemented)

clean:
	if [ -d target ]; then rm -r target; fi
