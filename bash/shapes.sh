#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

export GLS_RNG_TYPE=ranlxs2
inc_seed

declare COMB=$(shapec)
declare START=$(date +%s)

# False entrypoint
function main {
	report
	local n e c
	begin_osect "SHAPE[$COMB]"
	for n in ${NODES[*]}
	do
		for e in ${EDGEP[*]}
		do
			c=0;
			while [ $c -lt $SCNT ]
			do
				shape_create $n $e $c
				((c++))
			done
		done
	done
	end_osect

	local mins=$(min_elapsed $START)
	echo "Duration: $mins m Log: shapes.log"
	
	return 0;
}

function report {
	echo "Creating base graphs with parameters:"
	echo -e "\tNodes:\t${NODES[@]} ${#NODES[@]}"
	echo -e "\tEdegeP:\t${EDGEP[@]}"
	echo -e "\tJobs:\t$JOBS"
}

function shape_create {
	local nodes=$1;
	local edgep=$2;
	local count=$3;

	local name=$(shape_name $nodes $edgep $count)
	local cmd="dts-gen-nodes -n $nodes -e $edgep -o $name"
	echo $cmd >> shapes.log
	job_submit "$cmd"

	local frac=$(pcomplete $COMB ${FJOBS[done]})
	str=$(printf "%i[%s%%]" ${FJOBS[done]} $frac)
	add_o " $str elapsed:" $(min_elapsed $START) "m "
	add_o "remain:" $(min_remain $frac $START) "m"
	newl_o
}

main
exit $?
