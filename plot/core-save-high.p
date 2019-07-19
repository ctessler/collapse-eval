# -*- mode: gnuplot; -*-
#
set terminal epslatex standalone color
set termoption dashed

set key opaque
set grid

set ylabel "Number of Cores" rotate parallel
# set xlabel "Heuristic"

set output "core-save-high.tex"
set title "Average Number of Cores Saved Per Task"

set boxwidth 0.5
set style fill solid

plot "../data/core-save.dat" using 2:xtic(1) title "m high" with boxes
