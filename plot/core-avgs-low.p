# -*- mode: gnuplot; -*-
#
set terminal epslatex standalone color
set termoption dashed

set key opaque
set grid

set ylabel "Number of Cores" rotate parallel
# set xlabel "Heuristic"

set output "core-avgs-low.tex"
set title "Average Number of Cores Per Task"

set boxwidth 0.5
set style fill solid border -1 
plot "../data/core-avgs.dat" using 3:xtic(1) title "m low" with boxes lc "gray"


