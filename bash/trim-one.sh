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

	dts-infeas $file
	local infeas=$?
	if [[ 0 -ne $infeas ]]
	then
		keep=1
	fi
	local base=$(basename $file)
	base=${base%.*}
	for h in -a -b -p
	do
		dts-infeas ${base}${h}.dot
		if [[ 0 -ne $infeas ]]
		then
			keep=1
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
		echo $cmd
		exit -1
	fi
	 
	dts-collapse-list -L ${cands} $file -o $ofile
	rm $cands
}

main
exit $?
