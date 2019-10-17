# -*- mode: gnuplot; -*-
#
#set terminal epslatex standalone color
set terminal epslatex standalone color 'ptmb,17'
set termoption dashed

set key opaque
set grid

set ylabel "Collapsed" rotate parallel
# set xlabel "Heuristic"

set output "cand-collapse.tex"
set title "Candidates Collapsed"

set boxwidth 0.5
set style fill solid border -1
plot "../data/cnc-tots.dat" using 2:xtic(1) notitle with boxes lc "gray"


