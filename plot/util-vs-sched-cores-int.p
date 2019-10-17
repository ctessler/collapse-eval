# -*- mode: gnuplot; -*-
#
# set terminal epslatex standalone color
set terminal epslatex standalone color 'ptmb,17'
set termoption dashed

# Options set on the command line
# ifile - input file for data
# ofile - output file for tex
# cores - number of cores
# int - interval size

# No Collapse NonPreemptive
set linetype 1 linewidth 2 pointtype 4 linecolor "gray
# No Collapse Preemptive
set linetype 2 linewidth 2 pointtype 5 linecolor "black"
# Arbitrary
set linetype 3 linewidth 2 pointtype 6 linecolor "red"
# Max Benefit
set linetype 4 linewidth 2 pointtype 6 linecolor "green"
# Min Penalty
set linetype 5 linewidth 2 pointtype 7 linecolor "blue"

set key opaque
set grid
# set xrange [-.05:1.05]
# set yrange [-.05:1.05]

set ylabel "Schedulability Ratio" rotate parallel
set xlabel "Utilization"

set output ofile
set title "Utilization vs. Schedulability Ratio for m=" . cores . " [" . int . "]"

array names[8]
names[3] = "B-NP"
names[7] = "B-P"
names[4] = "OT-A"
names[5] = "OT-G"
names[6] = "OT-L"

array patterns[8]
patterns[3] = 3
patterns[7] = 3
patterns[4] = 0
patterns[5] = 1
patterns[6] = 2

array linetypes[8]
linetypes[3] = 1
linetypes[7] = 2
linetypes[4] = 3
linetypes[5] = 4
linetypes[6] = 5

set style data histogram
set style fill solid border -1
do for [ COL in "3" ] { print names[COL + 0] }
plot for [COL in "3 7 4 5 6"] ifile using (column(COL+0)/$2):xticlabels(1) \
     title names[COL+0] fs pattern patterns[COL+0] lt linetypes[COL+0]

# plot ifile using ($1):($3/$2) title "No Collapse" with linespoints lt 1, \
#      ifile using ($1):($7/$2) title "No Collapse-P" with linespoints lt 5, \
#      ifile using ($1):($4/$2) title "Arbitrary" with linespoints lt 2, \
#      ifile using ($1):($5/$2) title "Max Ben." with linespoints lt 3, \
#      ifile using ($1):($6/$2) title "Min Pen." with linespoints lt 4
