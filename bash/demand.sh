#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

export GLS_RNG_TYPE=ranlxs2
inc_seed

declare COMB=$(demandc)
declare START=$(date +%s)

# False entrypoint
function main {
	report
	begin_osect "DEMAND[$COMB]"
	local n
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
						demand_set $n $e $c $o $f
					done
				done
				((c++))
			done
		done
	done
	end_osect

	local mins=$(min_elapsed $START)
	echo "Duration: $mins m Log: demand.log"
	
	return 0;
}

function report {
	echo "Creating base graphs with parameters:"
	echo -e "\tNodes:\t${NODES[@]} ${#NODES[@]}"
	echo -e "\tEdegeP:\t${EDGEP[@]}"
	echo -e "\tOjbs:\t${OBJS[@]}"
	echo -e "\tJobs:\t$JOBS"
}

function demand_set {
	local nodes=$1;
	local edgep=$2;
	local count=$3;
	local obj=$4;
	local f=$5;

	local sname=$(shape_name $nodes $edgep $count)
	local dname=$(demand_name $nodes $edgep $count $obj $f)
	local cmd="dts-demand -t ../shape/${sname} -w ${WCET1} -j $obj -f $f"
	cmd="${cmd} -o $dname"
	echo $cmd >> demand.log
	job_submit "$cmd"

	local frac=$(pcomplete $COMB ${FJOBS[done]})
	str=$(printf "%i[%s%%]" ${FJOBS[done]} $frac)
	add_o " $str elapsed:" $(min_elapsed $START) "m "
	add_o "remain:" $(min_remain $frac $START) "m"
	newl_o
}

main
exit $?
