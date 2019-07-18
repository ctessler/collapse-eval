# -*- mode: gnuplot; -*-
#
set terminal epslatex standalone color
set termoption dashed

set key opaque
set grid

set ylabel "Critical Path Length" rotate parallel
# set xlabel "Heuristic"

set output "cp-avgs.tex"
set title "Average Critical Path Length"

set boxwidth 0.5
set style fill solid
plot "../data/cp-len.dat" using 2:xtic(1) notitle with boxes


