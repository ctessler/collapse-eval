#!/bin/bash

function main {
	local ifile=$1 ; shift
	local interval=$1; shift
	local cores=$1; shift	

	header
	local lastu=0
	local total=0
	local nc=0
	local ca=0
	local cb=0
	local cp=0
	local ncp=0
	while read line
	do
		local vals=($line)
		local vcores=${vals[1]}
		if [ $cores -ne $vcores ] ; then
			continue
		fi
		
		local util=${vals[0]}
		(( total += vals[2] ))
		(( nc += vals[3] ))
		(( ca += vals[4] ))
		(( cb += vals[5] ))
		(( cp += vals[6] ))
		(( ncp += vals[7] ))

		local next=$(echo "($util - $lastu) >= $interval" | bc -l)
		if [[ $next -eq 1 ]] ; then
			pline $lastu $total $nc $ca $cb $cp $ncp

			(( lastu += $interval ))
			(( total = nc = ca = cb = cp = ncp = 0 ))
		fi
	done < <(grep -v \# $ifile)
}

function header {
	printf "#%4s %6s %4s %4s %4s %4s %4s\n" \
	       UTIL TOTAL NC CA CB CP NCP
}

function pline {
	printf "%5s %6d %4d %4d %4d %4d %4d\n" \
	       $*
}

main $@
exit $?
