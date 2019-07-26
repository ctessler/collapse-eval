#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

export GLS_RNG_TYPE=ranlxs2
inc_seed

declare COMB=$(find ../trim -name "*.dot" | wc -l)
declare LOG=util.log
declare START=$(date +%s)

# False entrypoint
function main {
	begin_osect "UTIL[$COMB] "
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

main
exit $?
