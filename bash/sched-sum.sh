#!/bin/bash

declare TOTAL		# Total number of tasks
declare NC_COUNT	# No collapse count
declare CA_COUNT	# Arbitrary count
declare CB_COUNT	# Max Benefit count
declare CP_COUNT	# Min Penalty count

echo "SCHEDULABILITY RESULTS"
TOTAL=$(grep -v \# sched.dat | wc -l)
echo "Number of Task Sets: $TOTAL"
NC_COUNT=$(grep -v \# sched.dat | awk '{print $3}' | sed -n /yes/p | wc -l)
NA_COUNT=$(grep -v \# sched.dat | awk '{print $4}' | sed -n /yes/p | wc -l)
NB_COUNT=$(grep -v \# sched.dat | awk '{print $5}' | sed -n /yes/p | wc -l)
NP_COUNT=$(grep -v \# sched.dat | awk '{print $6}' | sed -n /yes/p | wc -l)

function pct {
	local p=$(echo "$1 / $2 * 100" | bc -l)

	printf "%0.2f" $p
}

echo "Schedulable with collapse heuristic:"
echo "None		$NC_COUNT" $(pct $NC_COUNT $TOTAL) "%"
echo "Arbitrary	$NA_COUNT" $(pct $NA_COUNT $TOTAL) "%"
echo "Max Ben.	$NB_COUNT" $(pct $NB_COUNT $TOTAL) "%"
echo "Min Pen.	$NP_COUNT" $(pct $NP_COUNT $TOTAL) "%"

