#!/bin/bash
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
	begin_osect "DEADLINE[$COMB]"
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
						local u
						for u in ${UTILS[*]}
						do
							percpf $n $e $c $o $f $u
						done
					done
				done
				((c++))
			done
		done
	done
	end_osect
	job_drain
	
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

function percpf {
	local nodes=$1; shift;
	local edgep=$1; shift;
	local count=$1; shift;
	local objs=$1; shift;
	local growf=$1; shift;
	local util=$1; shift;

	local cpf
	for cpf in ${CPFAC[*]}
	do
		deadline_set $nodes $edgep $count $objs $growf $util $cpf
	done
}

function deadline_set {
	local nodes=$1;
	local edgep=$2;
	local count=$3;
	local obj=$4;
	local f=$5;
	local u=$6;
	local cpf=$7;

	local pname=$(period_name $nodes $edgep $count $obj $f $u)
	local dname=$(deadline_name $nodes $edgep $count $obj $f $u $cpf)
	if [[ $? -ne 0 ]]
	then
		echo "Error!\n"
		exit -1
	fi
	local cmd="dts-deadline -t ../period/${pname} -c $cpf"
	cmd="${cmd} -o $dname"
	echo $cmd >> $LOG
	job_submit "$cmd"

	local frac=$(pcomplete $COMB ${FJOBS[done]})
	str=$(printf "%i[%s%%]" ${FJOBS[done]} $frac)
	add_o " $str elapsed:" $(min_elapsed $START) "m "
	add_o "remain:" $(min_remain $frac $START) "m"
	newl_o
}

main
exit $?
