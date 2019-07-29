# -*- mode: gnuplot; -*-
#
set terminal epslatex standalone color
set termoption dashed

# No Collapse
set linetype 1 linewidth 2 pointtype 4 linecolor "black"
# Arbitrary
set linetype 2 linewidth 2 pointtype 5 linecolor "green"
# Max Benefit
set linetype 3 linewidth 2 pointtype 6 linecolor "blue"
# Min Penalty
set linetype 4 linewidth 2 pointtype 7 linecolor "purple"

set key opaque
set grid
# set xrange [-.05:1.05]
# set yrange [-.05:1.05]

set ylabel "Schedulability Ratio" rotate parallel
set xlabel "Utilization"


set output "util-vs-sched-cores-32.tex"
set title "Utilization vs. Schedulability Ratio for m=32"

file="../sched-util/util-sum-by-cores.dat"
# $2 == 32 <-- number of cores
cmd="< awk '{if ($2 == 32) print}' ../sched-util/util-sum-by-cores.dat"

plot cmd using ($1):($4/$3) title "No Collapse" with linespoints lt 1, \
     cmd using ($1):($5/$3) title "Arbitrary" with linespoints lt 2, \
     cmd using ($1):($6/$3) title "Max Ben." with linespoints lt 3, \
     cmd using ($1):($7/$3) title "Min Pen." with linespoints lt 4
