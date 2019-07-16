#!/bin/bash
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
	rm -f unsorted.util
	rm -f sorted.util

	find ../trim -name "*.dot" -exec ../bash/util-one.sh {} > unsorted.util \;
	add_o $cmd
	$cmd
	
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

main
exit $?
