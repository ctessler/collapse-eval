# -*- mode: gnuplot; -*-
#
set terminal epslatex standalone color
set termoption dashed

#
# Variables from the command line
#
# ifile -- input data file
# ofile -- output tex file

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

set output ofile
set title "Utilization vs. Schedulability Ratio [".int."]"

plot ifile using ($1):($3/$2) title "No Collapse" \
         with linespoints lt 1, \
     ifile using ($1):($7/$2) title "No Col. Preempt." with linespoints lt 5, \
     ifile using ($1):($4/$2) title "Arbitrary" with linespoints lt 2, \
     ifile using ($1):($5/$2) title "Max Ben." with linespoints lt 3, \
     ifile using ($1):($6/$2) title "Min Pen." with linespoints lt 4
