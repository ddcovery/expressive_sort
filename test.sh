#!/usr/bin/env sh

echo "D (LCD)"
ldc2 -O -release  --run sorted.d 
echo "javascript (node)"
node sorted.js 
echo "Crystal"
crystal sorted.cr --release 
echo "D (DMD)"
dmd -O -run sorted.d
echo "python"
python3 sorted.py
