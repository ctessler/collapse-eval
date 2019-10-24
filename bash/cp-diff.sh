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


	printf "#%-14s %7s %7s %7s %7s %7s %7s %7s %7s\n" \
	       TASKNAME NOCOLL ARB MAXB MINP dLa dLb dLp tasks > cp-delta.dat

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

	local aavg=$(avg_col cp-delta.dat 6)
	local bavg=$(avg_col cp-delta.dat 7)
	local pavg=$(avg_col cp-delta.dat 8)
	
	local tot=cp-len.dat
	printf "# Average Critical Path Length\n" > $tot
	printf "%10s %7.2f\n" B $ncavg >> $tot
	printf "%10s %7.2f\n" OT-A $acavg >> $tot
	printf "%10s %7.2f\n" OT-G $bcavg >> $tot
	printf "%10s %7.2f\n" OT-L $pcavg >> $tot		

	local sum=cp-sum.dat
	printf "# Average Critical Path Length Extension\n" > $sum
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


function avg_item {
	local num=$1; shift;
	local den=$1; shift;

	local avg=$(echo "$num / $den" | bc -l)

	printf "%0.2f" $avg
}

function cp_data {
	local base=$1
	local aname=$(echo $base | sed s/\.dts/-a.dts/)
	local bname=$(echo $base | sed s/\.dts/-b.dts/)
	local pname=$(echo $base | sed s/\.dts/-p.dts/)		

	local ntasks=$(wc -l $base | awk '{print $1}' )
	(( ntasks -= 2 ))
	
	local nclen=$(sum_cpathlen $base)
	local aclen=$(sum_cpathlen $aname)
	local bclen=$(sum_cpathlen $bname)
	local pclen=$(sum_cpathlen $pname)

	nclen=$(avg_item $nclen $ntasks)
	aclen=$(avg_item $aclen $ntasks)	
	bclen=$(avg_item $bclen $ntasks)
	pclen=$(avg_item $pclen $ntasks)

	local deltaa=$(echo $aclen - $nclen | bc -l)
	local deltab=$(echo $bclen - $nclen | bc -l)
	local deltap=$(echo $pclen - $nclen | bc -l)	

	local name=$(basename $base)
	printf "%-15s %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %6d\n" \
	       $name $nclen $aclen $bclen $pclen $deltaa $deltab $deltap $ntasks
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
