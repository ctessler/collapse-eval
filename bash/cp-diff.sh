#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

declare LOG=cp-diff.log
declare START=$(date +%s)
declare TASKSETS=0

# False entrypoint
function main {
	local n
	rm -f unsorted.util
	rm -f sorted.util

	TASKSETS=$(find ../tasksets/ -name "*.dts" | \
			   grep -v '\-[abp]' | sort -n | wc -l)
	begin_osect "CP_DIFF[$TASKSETS] "


	printf "#%-14s %6s %6s %6s %6s %6s %6s %6s\n" \
	       TASKNAME NOCOLL ARB MAXB MINP dLa dLb dLp > cp-delta.dat

	for line in $(find ../tasksets/ -name "*.dts" | grep -v '\-[abp]' \
			      | sort -n)
	do
		cp_data $line >> cp-delta.dat
		add_o +
	done
	end_osect

	local ncavg=$(avg_col cp-delta.dat 2)
	local acavg=$(avg_col cp-delta.dat 3)
	local bcavg=$(avg_col cp-delta.dat 4)
	local pcavg=$(avg_col cp-delta.dat 5)	
	
	local asum=$(awk '{s+=$6} END {print s}' cp-delta.dat)
	local bsum=$(awk '{s+=$7} END {print s}' cp-delta.dat)
	local psum=$(awk '{s+=$8} END {print s}' cp-delta.dat)

	local aavg=$(echo $asum / $TASKSETS | bc -l)
	local bavg=$(echo $bsum / $TASKSETS | bc -l)	
	local pavg=$(echo $psum / $TASKSETS | bc -l)

	local tot=cp-len.dat
	printf "# Average Critical Path Length\n" > $tot
	printf "%10s %6.2f\n" No-Collapse $ncavg >> $tot
	printf "%10s %6.2f\n" Arbitrary $acavg >> $tot
	printf "%10s %6.2f\n" Max-Ben. $bcavg >> $tot
	printf "%10s %6.2f\n" Min-Pen. $pcavg >> $tot		

	local sum=cp-sum.dat
	printf "# Average Critical Path Length Extension\n" > $sum
	printf "%10s %6.2f\n" Arbitrary $aavg >> $sum
	printf "%10s %6.2f\n" Max-Ben. $bavg >> $sum
	printf "%10s %6.2f\n" Min-Pen. $pavg >> $sum		

	local mins=$(min_elapsed $START)
	echo "Duration: $mins m Log: $LOG"
	
	return 0;
}

function avg_col {
	local file=$1; shift;
	local col=$1; shift

	local sum=$(awk "{s+=\$$col} END {print s}" $file)
	local avg=$(echo "$sum / $TASKSETS" | bc -l)

	echo $avg
}


function cp_data {
	local base=$1
	local aname=$(echo $base | sed s/\.dts/-a.dts/)
	local bname=$(echo $base | sed s/\.dts/-b.dts/)
	local pname=$(echo $base | sed s/\.dts/-p.dts/)		

	local nclen=$(sum_cpathlen $base)
	local aclen=$(sum_cpathlen $aname)
	local deltaa deltab deltap
	(( deltaa = aclen - nclen ))
	local bclen=$(sum_cpathlen $bname)
	(( deltab = bclen - nclen ))
	local pclen=$(sum_cpathlen $pname)
	(( deltap = pclen - nclen ))

	local name=$(basename $base)
	printf "%-15s %6d %6d %6d %6d %6d %6d %6d\n" \
	       $name $nclen $aclen $bclen $pclen $deltaa $deltab $deltap
}

function sum_cpathlen {
	local file=$1

	local cmd="dts-print ../tasksets/$file"
	local v
	local clen=0
	while read -r v
	do
		local c=$(echo $v | grep -v \# | awk '{print $5}')
		(( clen += c ))
	done < <($cmd)

	echo $clen
}
	
main
exit $?
