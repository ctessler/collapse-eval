#!/bin/bash
#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

declare LOG=cp-diff.log
declare START=$(date +%s)
declare TASKSETS=0

# False entrypoint
function main {
	report

	local n
	rm -f unsorted.util
	rm -f sorted.util

	TASKSETS=$(wc -l base.list | awk '{print $1}')
	begin_osect "CP_DIFF[$TASKSETS]"


	printf "#%-14s %6s %6s %6s %6s %6s %6s %6s\n" \
	       TASKNAME NOCOLL ARB MAXB MINP dLa dLb dLp > cp-delta.dat
	local line
	while read -r line
	do
		cp_data $line >> cp-delta.dat
		add_o +
	done < base.list
	end_osect

	local ncavg=$(avg_col cp-delta.dat 2)
	echo $ncavg
	
	local asum=$(awk '{s+=$6} END {print s}' cp-delta.dat)
	local bsum=$(awk '{s+=$7} END {print s}' cp-delta.dat)
	local psum=$(awk '{s+=$8} END {print s}' cp-delta.dat)

	local aavg=$(echo $asum / $TASKSETS | bc -l)
	local bavg=$(echo $bsum / $TASKSETS | bc -l)	
	local pavg=$(echo $psum / $TASKSETS | bc -l)

	printf "# Average Critical Path Length Information\n" > cp-sum.dat
	printf "# Average Length\n"
	printf "#5s %6s %6s %6s %6s" TASKS NOCOLL ARB MAXB MINP >> cp-sum.dat

	printf "# Average Critical Path Extension L's\n" > cp-sum.dat
	printf "#%4s %6s %6s %6s\n" TASKS ARB MAXB MINP >> cp-sum.dat
	printf "%6d %6.2f %6.2f %6.2f\n" $TASKSETS $aavg $bavg $pavg >> cp-sum.dat
	
	local mins=$(min_elapsed $START)
	echo "Duration: $mins m Log: $LOG"
	
	return 0;
}

function report {
	echo "Creating base graphs with parameters:"
	echo -e "\tNodes:\t${NODES[@]} ${#NODES[@]}"
	echo -e "\tEdegeP:\t${EDGEP[@]}"
	echo -e "\tOjbs:\t${OBJS[@]}"
	echo -e "\tGrowF:\t${GROWF[@]}"	
	echo -e "\tUtils:\t${UTILS[@]}"
	echo -e "\tJobs:\t$JOBS"
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
