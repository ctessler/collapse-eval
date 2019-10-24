# -*- mode: gnuplot; -*-
#
# set terminal epslatex standalone color
set terminal epslatex standalone color 'ptmb,17'
set termoption dashed

set key opaque
set grid

set ylabel "Critical Path Length" rotate parallel
# set xlabel "Heuristic"

set output "cp-avgs.tex"
set title "Average Critical Path Length Per Task"

set boxwidth 0.5
set style fill solid border -1 
plot "../data/cp-len-pt.dat" using 2:xtic(1) notitle with boxes lc "gray"


