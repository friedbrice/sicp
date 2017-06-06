#!/bin/bash

mkdir -p target
pandoc --to latex --output target/sicp.pdf --from markdown < sicp.md
