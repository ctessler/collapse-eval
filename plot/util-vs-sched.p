# -*- mode: gnuplot; -*-
#
# set terminal epslatex standalone color
set terminal epslatex standalone color 'ptmb,17'
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

set output "util-vs-sched.tex"
set title "Utilization vs. Schedulability Ratio"

plot "../data/util-sum.dat" using ($1):($3/$2) title "No Collapse" \
        with linespoints lt 1, \
     "../data/util-sum.dat" using ($1):($7/$2) title "No Col. Preempt." with linespoints lt 5, \
     "../data/util-sum.dat" using ($1):($4/$2) title "Arbitrary" with linespoints lt 2, \
     "../data/util-sum.dat" using ($1):($5/$2) title "Max Ben." with linespoints lt 3, \
     "../data/util-sum.dat" using ($1):($6/$2) title "Min Pen." with linespoints lt 4
