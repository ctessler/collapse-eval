i#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

export GLS_RNG_TYPE=ranlxs2
inc_seed

declare COMB=$(deadlinec)
declare LOG=util.log
declare START=$(date +%s)

# False entrypoint
function main {
	report
	begin_osect "UTIL[$COMB]"
	local n
	rm unsorted.util
	rm sorted.util

	find ../trim -name "*.dot" -exec ../bash/util-one.sh {} > unsorted.util \;
	
	end_osect

	sort -n unsorted.util > sorted.util

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

function add_util {
	echo $1
	return 0
	
	local nodes=$1;
	local edgep=$2;
	local count=$3;
	local obj=$4;
	local f=$5;
	local u=$6;

	local dname=$(deadline_name $nodes $edgep $count $obj $f $u)
	local cmd="dts-util ../deadline/${dname}"
	cmd="${cmd}"
	util=$($cmd)
	echo "$util $dname" >> unsorted.util
	echo $cmd >> $LOG
	add_o .
}

main
exit $?
