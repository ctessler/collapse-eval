i#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

export GLS_RNG_TYPE=ranlxs2
inc_seed

declare COMB=$(deadlinec)
declare LOG=deadline.log
declare START=$(date +%s)

# False entrypoint
function main {
	report
	begin_osect "UTIL[$COMB]"
	local n
	rm unsorted.util
	rm sorted.util
	for n in ${NODES[*]}
	do
		local e
		for e in ${EDGEP[*]}
		do
			local c=0;
			while [ $c -lt $SCNT ]
			do
				local o
				for o in ${OBJS[*]}
				do
					local f
					for f in ${GROWF[*]}
					do
						local u
						for u in ${UTILS[*]}
						do
							add_util \
								$n $e $c $o $f $u

						done
					done
				done
				((c++))
			done
		done
	done
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
