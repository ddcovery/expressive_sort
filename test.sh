#!/usr/bin/env sh
echo "compiler,lang,size,ms"
ldc2 -O5 -release -enable-cross-module-inlining --run sorted.d | sed "s/^/\"ldc2\",\"D\",/"
sleep 30s
crystal run sorted.cr --release  | sed "s/^/\"crystal\",\"Crystal\",/"
sleep 30s
node sorted.js  | sed "s/^/\"node\",\"Javascript\",/"
sleep 30s
nim c -d:danger --gc:refc -x --opt:speed -o:sorted_nim --verbosity:0 sorted.nim 2>/dev/null && ./sorted_nim | sed "s/^/\"nim\",\"Nim\",/" && rm sorted_nim
sleep 30s
scala  -J-Xmx2048m -optimise -nc -nobootcp sorted.scala | sed "s/^/\"scala\",\"Scala\",/"
sleep 30s
dmd -O -release -run sorted.d | sed "s/^/\"dmd\",\"D\",/"
sleep 30s
julia -O3 --inline=yes --check-bounds=no sorted.jl | sed "s/^/\"julia\",\"julia\",/"
sleep 30s
python3 -OO sorted.py | sed "s/^/\"python3\",\"Python\",/"
