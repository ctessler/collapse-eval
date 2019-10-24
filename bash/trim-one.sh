#!/bin/bash

declare file=$1
if [[ -z "$file" ]] ; then
	echo "A file is required"
	echo "	trim-one.sh <FILE>"
	exit 1
fi

# False entry point
function main {
	# Collapse for each of the heuristics
	local h
	for h in -a -b -p
	do
		collapse $file $h
	done

	# If any are feasible leave all of them
	local keep=0

	local res=$(dts-infeas $file)
	if [[ $? -ne 0 ]]
	then
		echo "Error!"
		exit -1
	fi
	if [[ $res != "INFEASIBLE" ]]
	then
		ngc $file
		if [[ $? -eq 0 ]]
		then
			keep=1
		fi
	fi
	
	local base=$(basename $file)
	base=${base%.*}
	for h in -a -b -p
	do
		res=$(dts-infeas ${base}${h}.dot)
		if [[ $? -ne 0 ]]
		then
			echo "Error: dts-infeas ${base}${h}.dot"
			exit -1
		fi
		if [[ $res != "INFEASIBLE" ]]
		then
			ngc ${base}${h}.dot
			if [[ $? -eq 0 ]] 
			then
				keep=1
			fi
		fi
	done

	if [[ 0 -eq $keep ]]
	then
		for h in -a -b -p
		do
			rm ${base}${h}.dot
		done
	else
		cp $file .
	fi

	return 0
}

#
# Usage: collapse $file $heuristic
#        $heuristic \in { -a -b -p }
#
function collapse {
	local file=$1; shift
	local heur=$1; shift

	local base=$(basename $file)
	base=${base%.*}
	local cands=${base}${heur}.cand
	local ofile=${base}${heur}.dot

	cmd="dts-cand-order -t $file -o $cands ${heur}"
	$cmd
	if [[ $? -ne 0 ]]
	then
		echo "Error!: $cmd"
		exit -1
	fi
	 
	dts-collapse-list -L ${cands} $file -o $ofile
	rm $cands
}

#
# Usage: ngc $file
#
# Returns true if the number of nodes is greater than the number of
# cores required for a high utilzation task, false otherwise
#
function ngc {
	local file=$1; shift;

	local nodes=$(dt-print $file | sed 1d | awk '{ print $2 }')
	local cores=$(dt-print $file | sed 1d | awk '{ print $14 }')

	if [ -z $cores ] ; then
		echo "ngc Error collecting cores for $1!"
		exit -1;
	fi

	if [ $nodes -gt $cores ] ; then
		return 0;
	fi

	return -1;
}


main
exit $?
