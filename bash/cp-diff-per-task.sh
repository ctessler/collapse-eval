#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

declare LOG=cp-diff-pt.log
declare START=$(date +%s)
declare TASKSETS=0

# False entrypoint
function main {
	local n
	rm -f unsorted.util
	rm -f sorted.util

	TASKSETS=$(find ../trim/ -name "*.dot" | \
			   grep -v '\-[abp]' | sort -n | wc -l)
	begin_osect "CP_DIFF[$TASKSETS] "

	local delta=cp-delta-pt.dat
	printf "#%-14s %7s %7s %7s %7s %7s %7s %7s\n" \
	       TASKNAME NOCOLL ARB MAXB MINP dLa dLb dLp > $delta

	for line in $(find ../trim/ -name "*.dot" | grep -v '\-[abp]' \
			      | sort -n)
	do
		cp_data $line >> $delta
		(( ++c ))
		add_o "$c "
	done
	end_osect

	local ncavg=$(avg_col $delta 2)
	local acavg=$(avg_col $delta 3)
	local bcavg=$(avg_col $delta 4)
	local pcavg=$(avg_col $delta 5)

	local aavg=$(avg_col $delta 6)
	local bavg=$(avg_col $delta 7)
	local pavg=$(avg_col $delta 8)
	
	local tot=cp-len-tp.dat
	printf "# Average Critical Path Length Per Task\n" > $tot
	printf "%10s %7.2f\n" B $ncavg >> $tot
	printf "%10s %7.2f\n" OT-A $acavg >> $tot
	printf "%10s %7.2f\n" OT-G $bcavg >> $tot
	printf "%10s %7.2f\n" OT-L $pcavg >> $tot		

	local sum=cp-sum-tp.dat
	printf "# Average Critical Path Length Extension Per Task\n" > $sum
	printf "%10s %7.2f\n" OT-A $aavg >> $sum
	printf "%10s %7.2f\n" OT-G $bavg >> $sum
	printf "%10s %7.2f\n" OT-L $pavg >> $sum		

	local mins=$(min_elapsed $START)
	echo "Duration: $mins m Log: $LOG"
	
	return 0;
}

function avg_col {
	local file=$1; shift;
	local col=$1; shift

	local avg=$(awk "{s+=\$$col} END {print s / (NR - 1)}" $file)

	echo $avg
}


function cp_data {
	local base=$1
	local aname=$(echo $base | sed s/\.dot/-a.dot/)
	local bname=$(echo $base | sed s/\.dot/-b.dot/)
	local pname=$(echo $base | sed s/\.dot/-p.dot/)		

	local nclen=$(cpathlen $base)
	local aclen=$(cpathlen $aname)
	local bclen=$(cpathlen $bname)
	local pclen=$(cpathlen $pname)

	local deltaa=$(echo $aclen - $nclen | bc -l)
	local deltab=$(echo $bclen - $nclen | bc -l)
	local deltap=$(echo $pclen - $nclen | bc -l)	

	local name=$(basename $base)
	printf "%-15s %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\n" \
	       $name $nclen $aclen $bclen $pclen $deltaa $deltab $deltap
}

function cpathlen {
	local file=$1

	local clen=$(dt-print ../tasksets/$file | grep -v \# | awk '{print $4}')

	echo $clen
}
	
main
exit $?
