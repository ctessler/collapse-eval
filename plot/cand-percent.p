# -*- mode: gnuplot; -*-
#
set terminal epslatex standalone color
set termoption dashed

set key opaque
set grid

set ylabel "Collapsed" rotate parallel
# set xlabel "Heuristic"

set output "cand-percent.tex"
set title "Percent of Candidates Collapsed"

set boxwidth 0.5
set style fill solid border -1
plot "../data/cnc-sum.dat" using 2:xtic(1) notitle with boxes lc "gray"


