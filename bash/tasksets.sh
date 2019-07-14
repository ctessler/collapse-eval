#!/bin/bash

contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

export GLS_RNG_TYPE=ranlxs2
inc_seed

declare COMB=$(tasksetc)
declare LOG=tasksets.log
declare START=$(date +%s)

declare TASKCOUNT=0
# False entrypoint
function main {
	report

	grep -v '\-[abp]' ../utils/sorted.util > coll-non.list
	begin_osect "TASKSETS[$COMB]"
	
	local u
	for u in ${TASKSET_UTILS[*]}
	do
		local v=0
		while [[ $v -lt ${TCNT} ]]
		do
			taskset_create $u $v
			((v++))
		done
	done

	end_osect

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


function line_by_no {
	local no=$1
	local line=$(sed -n ${no}p coll-non.list)

	echo $line
	
}

function taskset_create {
	local tgt_util=$1;
	local var=$2;

	local util=0;
	local name=$(printf "u%02.2f-%03d.dts" $tgt_util $var)
	cat <<EOF > $name
dts-version = 1.0;
tasks = (
EOF
	local first=1
	while (( $(echo "$util < $tgt_util" | bc -l) ))
	do
		local remain=$( echo "$tgt_util - $util" | bc -l )
		local line=$( ../bash/best-fit.pl -f coll-non.list $remain)
		if [[ $? -ne 0 ]]
		then
			echo "Error!"
			exit -1
		fi
		
		local u=$(echo $line | awk '{print $1}')
		local t=$(echo $line | awk '{print $2}')
		util=$(echo "$util + $u" | bc -l)

		if [[ $first -eq 0 ]]
		then
			echo "," >> $name
		fi
		first=0
		echo -n -e "\t\"../trim/$t\"" >> $name
	done
	cat <<EOF >> $name
);	
EOF
	((TASKCOUNT++))
	add_o "$TASKCOUNT "
}

main
exit $?

