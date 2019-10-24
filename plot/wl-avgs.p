# -*- mode: gnuplot; -*-
#
# set terminal epslatex standalone color
set terminal epslatex standalone color 'ptmb,17'
set termoption dashed

set key opaque
set grid

set ylabel "Workload" rotate parallel
# set xlabel "Heuristic"

set output "wl-avgs.tex"
set title "Average Workload Per Task"

set boxwidth 0.5
set style fill solid border -1 
plot "../data/wl-avgs-pt.dat" using 2:xtic(1) notitle with boxes lc "gray"


