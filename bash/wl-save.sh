#!/bin/bash
#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

declare LOG=wl-save.log
declare START=$(date +%s)
declare TASKSETS=0

# False entrypoint
function main {
	local n
	rm -f unsorted.util
	rm -f sorted.util

	TASKSETS=$(find ../tasksets/ -name "*.dts" | \
			   grep -v '\-[abp]' | sort -n | wc -l)
	begin_osect "WL_SAVE[$TASKSETS] "

#	printf "#%-14s %7s %7s %7s %7s %7s %7s %7s %6s\n" \
#	       TASKNAME NOCOLL ARB MAXB MINP dCa dCb dCp tasks> wl-delta.dat

	for line in $(find ../tasksets/ -name "*.dts" | grep -v '\-[abp]' \
			      | sort -n)
	do
#		wl_data $line >> wl-delta.dat
		(( ++c ))
		add_o "$c "
	done
	end_osect
	
	local ncavg=$(avg_col wl-delta.dat 2)
	local acavg=$(avg_col wl-delta.dat 3)
	local bcavg=$(avg_col wl-delta.dat 4)
	local pcavg=$(avg_col wl-delta.dat 5)

	local aavg=$(avg_col wl-delta.dat 6)
	local bavg=$(avg_col wl-delta.dat 7)
	local pavg=$(avg_col wl-delta.dat 8)
	
	local avgs=wl-avgs.dat
	printf "# Average workloads\n" > $avgs
	printf "%10s %7.2f\n" B $ncavg >> $avgs
	printf "%10s %7.2f\n" OT-A $acavg >> $avgs
	printf "%10s %7.2f\n" OT-G $bcavg >> $avgs
	printf "%10s %7.2f\n" OT-L $pcavg >> $avgs

	local sum=wl-sum.dat
	printf "# Average workload savings\n" > $sum
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

function wl_data {
	local base=$1
	local aname=$(echo $base | sed s/\.dts/-a.dts/)
	local bname=$(echo $base | sed s/\.dts/-b.dts/)
	local pname=$(echo $base | sed s/\.dts/-p.dts/)

	local ntasks=$(wc -l $base | awk '{print $1}' )
	(( ntasks -= 2 ))

	local nwl=$(sum_workload $base)
	local awl=$(sum_workload $aname)
	local bwl=$(sum_workload $bname)
	local pwl=$(sum_workload $pname)

	nwl=$(avg_item $nwl $ntasks)
	awl=$(avg_item $awl $ntasks)
	bwl=$(avg_item $bwl $ntasks)
	pwl=$(avg_item $pwl $ntasks)	

	local deltaa=$(echo $nwl - $awl | bc -l)
	local deltab=$(echo $nwl - $bwl | bc -l)
	local deltap=$(echo $nwl - $pwl | bc -l)

	local name=$(basename $base)
	printf "%-15s %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %6d\n" \
	       $name $nwl $awl $bwl $pwl $deltaa $deltab $deltap $ntasks
}

function sum_workload {
	local file=$1

	local cmd="dts-print ../tasksets/$file"
	local v
	local wl=0
	while read -r v
	do
		local c=$(echo $v | grep -v \# | awk '{print $4}')
		(( wl += c ))
	done < <($cmd)

	echo $wl
}
	
main
exit $?
