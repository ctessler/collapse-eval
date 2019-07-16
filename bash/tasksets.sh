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

declare PRE="dts-version = 1.0;
tasks = ("
declare POST=");"
function taskset_create {
	local tgt_util=$1;
	local var=$2;

	local util=0;
	local name=$(printf "u%05.2f-%03d.dts" $tgt_util $var)
	local aname=$(printf "u%05.2f-%03d-a.dts" $tgt_util $var)
	local bname=$(printf "u%05.2f-%03d-b.dts" $tgt_util $var)
	local pname=$(printf "u%05.2f-%03d-p.dts" $tgt_util $var)
	for a in $name $aname $bname $pname
	do
		echo "$PRE" > $a
	done
	local first=1
	while (( $(echo "$util < $tgt_util" | bc -l) ))
	do
		local remain=$( echo "$tgt_util - $util" | bc -l )
		local line=$( ../bash/random-fit.pl -f coll-non.list -u $remain)
		echo "../bash/random-fit.pl -f coll-non.list -u $remain" >> $LOG
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
			for a in $name $aname $bname $pname
			do
				echo "," >> $a
			done
		fi
		first=0
		echo -n -e "\t\"../trim/$t\"" >> $name
		declare a=$(echo "$t" | sed 's/\.dot/-a.dot/')
		echo -n -e "\t\"../trim/$a\"" >> $aname
		declare b=$(echo "$t" | sed 's/\.dot/-b.dot/')
		echo -n -e "\t\"../trim/$b\"" >> $bname		
		declare p=$(echo "$t" | sed 's/\.dot/-p.dot/')		
		echo -n -e "\t\"../trim/$p\"" >> $pname
	done
	for a in $name $aname $bname $pname
	do
		echo "$POST" >> $a
	done

	((TASKCOUNT++))
	add_o "$TASKCOUNT "
}

main
exit $?

