#!/bin/bash

pandoc --to latex --output target/sicp.pdf --from markdown < sicp.md
