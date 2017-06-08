#!/bin/bash

function make_html {

  mkdir -p target

  pandoc --from=markdown \
         --to=html5 --standalone --mathjax \
         < sicp.md > target/sicp.html
}

function make_article {

  mkdir -p texbuild
  mkdir -p target

  pandoc --from=markdown \
         --to=latex --standalone \
         < sicp.md > texbuild/sicp-article.tex

  cd texbuild
  pdflatex sicp-article.tex
  mv sicp-article.pdf ../target/sicp-article.pdf
}

function make_beamer {

  mkdir -p texbuild
  mkdir -p target

  pandoc --from=markdown \
         --to=beamer --standalone \
         < sicp.md > texbuild/sicp-beamer.tex

  cd texbuild
  pdflatex sicp-beamer.tex
  mv sicp-beamer.pdf ../target/sicp-beamer.pdf
}

function make_lisp {
  echo "Function `make_lisp` not implemented!"
}

make_html
make_article
make_beamer
make_lisp
