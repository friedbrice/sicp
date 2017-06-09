#!/bin/bash

function make_html {
  mkdir -p target
  pandoc --to=html5 --standalone --mathjax --output=target/sicp.html sicp.md
  echo "Made target/sicp.html"
}

function make_article {
  mkdir -p target
  pandoc --to=latex --standalone --output=target/sicp-article.pdf sicp.md
  echo "Made target/sicp-article.pdf"
}

function make_beamer {
  echo "Function 'make_beamer' not implemented!"
}

function make_racket {
  echo "Function 'make_racket' not implemented!"
}

make_html
make_article
make_beamer
make_racket
