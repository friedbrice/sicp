#!/bin/bash

pandoc --to html5 --standalone --mathjax --from markdown < sicp.md > sicp.html
