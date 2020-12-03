#!/usr/bin/env sh
echo "compiler,lang,size,ms"
ldc2 -O5 -release -enable-cross-module-inlining --run sorted.d | sed "s/^/\"ldc2\",\"D\",/"
crystal run sorted.cr --release  | sed "s/^/\"crystal\",\"Crystal\",/"
node sorted.js  | sed "s/^/\"node\",\"Javascript\",/"
dmd -O -release -run sorted.d | sed "s/^/\"dmd\",\"D\",/"
julia -O3 --inline=yes --check-bounds=no sorted.jl | sed "s/^/\"julia\",\"julia\",/"
python3 -OO sorted.py | sed "s/^/\"python3\",\"Python\",/"

