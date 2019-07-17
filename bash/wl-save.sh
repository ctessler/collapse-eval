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
	report

	local n
	rm -f unsorted.util
	rm -f sorted.util

	TASKSETS=$(wc -l base.list | awk '{print $1}')
	begin_osect "WL_SAVE[$TASKSETS]"

	printf "#%-14s %4s %4s %4s\n" TASKNAME dCa dCb dCp > wl-delta.dat
	local line
	while read -r line
	do
		wl_data $line >> wl-delta.dat
		add_o +
	done < base.list
	end_osect

	local asum=$(awk '{s+=$2} END {print s}' wl-delta.dat)
	local bsum=$(awk '{s+=$3} END {print s}' wl-delta.dat)
	local psum=$(awk '{s+=$4} END {print s}' wl-delta.dat)

	local aavg=$(echo $asum / $TASKSETS | bc -l)
	local bavg=$(echo $bsum / $TASKSETS | bc -l)	
	local pavg=$(echo $psum / $TASKSETS | bc -l)		

	printf "# Average Workload Savings\n" > wl-sum.dat
	printf "#%4s %6s %6s %6s\n" TASKS ARB MAXB MINP >> wl-sum.dat
	printf "%6d %6.2f %6.2f %6.2f\n" $TASKSETS $aavg $bavg $pavg >> wl-sum.dat
	
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

function wl_data {
	local base=$1
	local aname=$(echo $base | sed s/\.dts/-a.dts/)
	local bname=$(echo $base | sed s/\.dts/-b.dts/)
	local pname=$(echo $base | sed s/\.dts/-p.dts/)		

	local nclen=$(sum_workload $base)
	local aclen=$(sum_workload $aname)
	(( aclen = nclen - aclen ))
	local bclen=$(sum_workload $bname)
	(( bclen = nclen - bclen ))
	local pclen=$(sum_workload $pname)
	(( pclen = nclen - pclen ))

	local name=$(basename $base)
	printf "%-15s %4d %4d %4d\n" $name $aclen $bclen $pclen
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
