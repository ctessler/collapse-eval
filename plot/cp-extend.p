# -*- mode: gnuplot; -*-
#
set terminal epslatex standalone color
set termoption dashed

set key opaque
set grid

set ylabel "Critical Path Length Extension" rotate parallel
# set xlabel "Heuristic"

set output "cp-extend.tex"
set title "Average Critical Path Length Extension"

set boxwidth 0.5
set style fill solid
plot "../data/cp-sum.dat" using 2:xtic(1) notitle with boxes

