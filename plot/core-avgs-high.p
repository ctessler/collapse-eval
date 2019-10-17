# -*- mode: gnuplot; -*-
#
# set terminal epslatex standalone color
set terminal epslatex standalone color 'ptmb,17'
set termoption dashed

set key opaque
set grid

set ylabel "Number of Cores" rotate parallel
# set xlabel "Heuristic"

set output "core-avgs-high.tex"
set title "Average Number of Cores Per Task"

set boxwidth 0.5
set style fill solid border -1 
plot "../data/core-avgs.dat" using 2:xtic(1) title "m high" with boxes lc "gray"


