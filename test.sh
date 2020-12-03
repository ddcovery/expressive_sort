#!/usr/bin/env sh
echo "compiler,lang,size,ms"
ldc2 -O5 -release -enable-cross-module-inlining --run sorted.d | sed "s/^/\"ldc2\",/"
crystal run sorted.cr --release  | sed "s/^/\"crystal\",/"
node sorted.js  | sed "s/^/\"node\",/"
dmd -O -release -run sorted.d | sed "s/^/\"dmd\",/"
python3 -OO sorted.py | sed "s/^/\"python3\",/"

