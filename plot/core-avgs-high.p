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
set title "Average ${|m_{high}|}$ Per Task Set"

set boxwidth 0.5
set style fill solid border -1 
#plot "../data/core-avgs.dat" using 2:xtic(1) title "m high" with boxes lc "gray"
plot "../data/core-avgs.dat" using 2:xtic(1) notitle with boxes lc "gray"


