#!/usr/bin/env sh
echo "D (DMD)"
dmd -O -release -run sorted.d
echo "D (LCD)"
ldc2 -O5 -release -enable-cross-module-inlining --run sorted.d 
echo "Crystal"
crystal run sorted.cr --release 
echo "javascript (node)"
node sorted.js 
echo "python"
python3 sorted.py
