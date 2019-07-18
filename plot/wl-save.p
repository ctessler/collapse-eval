# -*- mode: gnuplot; -*-
#
set terminal epslatex standalone color
set termoption dashed

set key opaque
set grid

set ylabel "Savings" rotate parallel
# set xlabel "Heuristic"

set output "wl-save.tex"
set title "Average Workload Savings"

set boxwidth 0.5
set style fill solid
plot "../data/wl-sum.dat" using 2:xtic(1) notitle with boxes


