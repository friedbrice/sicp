#!/bin/bash

mkdir -p target
pandoc --to html5 --standalone --mathjax --from markdown < sicp.md > target/sicp.html
