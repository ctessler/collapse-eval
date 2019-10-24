#!/bin/bash
#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

declare LOG=wl-save-pt.log
declare START=$(date +%s)
declare TASKSETS=0

# False entrypoint
function main {
	local n
	rm -f unsorted.util
	rm -f sorted.util

	TASKSETS=$(find ../trim/ -name "*.dot" | \
			   grep -v '\-[abp]' | sort -n | wc -l)
	begin_osect "WL_SAVE[$TASKSETS] "

	local delta=wl-delta-pt.dat
	printf "#%-14s %7s %7s %7s %7s %7s %7s %7s\n" \
	       TASKNAME NOCOLL ARB MAXB MINP dCa dCb dCp> $delta

	for line in $(find ../trim/ -name "*.dot" | grep -v '\-[abp]' \
			      | sort -n)
	do
		wl_data $line >> $delta
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
	
	local avgs=wl-avgs-pt.dat
	printf "# Average Workload Per Task\n" > $avgs
	printf "%10s %7.2f\n" B $ncavg >> $avgs
	printf "%10s %7.2f\n" OT-A $acavg >> $avgs
	printf "%10s %7.2f\n" OT-G $bcavg >> $avgs
	printf "%10s %7.2f\n" OT-L $pcavg >> $avgs

	local sum=wl-sum-pt.dat
	printf "# Average Workload Savings Per Task\n" > $sum
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


function wl_data {
	local base=$1
	local aname=$(echo $base | sed s/\.dot/-a.dot/)
	local bname=$(echo $base | sed s/\.dot/-b.dot/)
	local pname=$(echo $base | sed s/\.dot/-p.dot/)

	local nwl=$(task_workload $base)
	local awl=$(task_workload $aname)
	local bwl=$(task_workload $bname)
	local pwl=$(task_workload $pname)

	local deltaa=$(echo $nwl - $awl | bc -l)
	local deltab=$(echo $nwl - $bwl | bc -l)
	local deltap=$(echo $nwl - $pwl | bc -l)

	local name=$(basename $base)
	printf "%-15s %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\n" \
	       $name $nwl $awl $bwl $pwl $deltaa $deltab $deltap
}

function task_workload {
	local file=$1

	local wl=$(dt-print ../tasksets/$file | grep -v \# | awk '{print $3}')
	echo $wl
}
	
main
exit $?
