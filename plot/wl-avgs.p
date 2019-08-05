# -*- mode: gnuplot; -*-
#
set terminal epslatex standalone color
set termoption dashed

set key opaque
set grid

set ylabel "Workload" rotate parallel
# set xlabel "Heuristic"

set output "wl-avgs.tex"
set title "Average Workloads"

set boxwidth 0.5
set style fill solid border -1 
plot "../data/wl-avgs.dat" using 2:xtic(1) notitle with boxes lc "gray"


