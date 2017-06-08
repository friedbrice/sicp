#!/bin/bash

function make_html {

  mkdir -p target

  pandoc --from=markdown \
         --to=html5 --standalone --mathjax \
         < sicp.md > target/sicp.html

  echo "Made target/sicp.html"
}

function make_article {

  mkdir -p texbuild
  mkdir -p target

  pandoc --from=markdown \
         --to=latex --standalone \
         < sicp.md > texbuild/sicp-article.tex

  cd texbuild
  pdflatex -interaction=batchmode -halt-on-error sicp-article.tex
  cd ..
  mv texbuild/sicp-article.pdf target/sicp-article.pdf

  echo "Made target/sicp-article.pdf"
}

function make_beamer {

  # mkdir -p texbuild
  # mkdir -p target

  # pandoc --from=markdown \
  #        --to=beamer --standalone \
  #        < sicp.md > texbuild/sicp-beamer.tex

  # cd texbuild
  # pdflatex -interaction=batchmode -halt-on-error sicp-beamer.tex
  # cd ..
  # mv texbuild/sicp-beamer.pdf target/sicp-beamer.pdf

  echo "Function 'make_beamer' not implemented!"
}

function make_racket {
  echo "Function 'make_racket' not implemented!"
}

make_html
make_article
make_beamer
make_racket
