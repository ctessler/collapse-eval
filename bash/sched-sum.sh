#!/bin/bash

declare TOTAL		# Total number of tasks
declare NC_COUNT	# No collapse count
declare CA_COUNT	# Arbitrary count
declare CB_COUNT	# Max Benefit count
declare CP_COUNT	# Min Penalty count

declare ifile=$1

echo "SCHEDULABILITY RESULTS"
TOTAL=$(grep -v \# $ifile | wc -l)
echo "Number of Task Sets: $TOTAL"
NC_COUNT=$(grep -v \# $ifile | awk '{print $3}' | sed -n /yes/p | wc -l)
NA_COUNT=$(grep -v \# $ifile | awk '{print $4}' | sed -n /yes/p | wc -l)
NB_COUNT=$(grep -v \# $ifile | awk '{print $5}' | sed -n /yes/p | wc -l)
NP_COUNT=$(grep -v \# $ifile | awk '{print $6}' | sed -n /yes/p | wc -l)
NCP_COUNT=$(grep -v \# $ifile | awk '{print $7}' | sed -n /yes/p | wc -l)

function pct {
	local p=$(echo "$1 / $2 * 100" | bc -l)

	printf "%0.2f" $p
}

echo "Schedulable with collapse heuristic:"
echo "B-NP		$NC_COUNT" $(pct $NC_COUNT $TOTAL) "%"
echo "B-P	$NCP_COUNT" $(pct $NCP_COUNT $TOTAL) "%"
echo "OT-A	$NA_COUNT" $(pct $NA_COUNT $TOTAL) "%"
echo "OT-G	$NB_COUNT" $(pct $NB_COUNT $TOTAL) "%"
echo "OT-L	$NP_COUNT" $(pct $NP_COUNT $TOTAL) "%"

