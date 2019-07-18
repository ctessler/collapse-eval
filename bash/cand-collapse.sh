#!/bin/bash
#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

declare LOG=cnc-save.log
declare START=$(date +%s)
declare TASKSETS=0

# False entrypoint
function main {
	report

	local n
	rm -f unsorted.util
	rm -f sorted.util

	local count=$(ls ../trim/*.dot | grep -v '\-[abp]' | wc -l)
	begin_osect "CNC[$count] "

	local ofile=cand-collapse.dat

	printf "#%-14s %6s %6s %6s %6s\n" \
	       TASKNAME CANDS COLA COLB COLP > $ofile

	local line
	local c=0
	while read -r line
	do
		coll_data $line >> $ofile
		(( c++ ))
		add_o "$c "
	done < <(ls ../trim/*.dot | grep -v '\-[abp]')
	end_osect

	local csum=$(awk '{s+=$2} END {print s}' $ofile)
	local asum=$(awk '{s+=$3} END {print s}' $ofile)
	local bsum=$(awk '{s+=$3} END {print s}' $ofile)
	local psum=$(awk '{s+=$4} END {print s}' $ofile)

	local aavg=$(echo "$asum / $csum * 100" | bc -l)
	local bavg=$(echo "$bsum / $csum * 100" | bc -l)	
	local pavg=$(echo "$psum / $csum * 100" | bc -l)		

	printf "# Average Collapses\n" > cnc-sum.dat
	printf "#%4s %6s %6s %6s\n" CANDS ARB MAXB MINP >> cnc-sum.dat
	printf "%6d %6.2f %6.2f %6.2f\n" $csum $aavg $bavg $pavg >> cnc-sum.dat
	
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

function coll_data {
	local base=$1
	local aname=$(echo $base | sed s/\.dot/-a.dot/)
	local bname=$(echo $base | sed s/\.dot/-b.dot/)
	local pname=$(echo $base | sed s/\.dot/-p.dot/)		

	local cands=$(dts-candidates -c $base | \
			      sed -n 's/Total Candidates: //p')
	local acol=$(sed -n 's/\t\tcollapsed=\(.*\),/\1/p' $aname)
	local bcol=$(sed -n 's/\t\tcollapsed=\(.*\),/\1/p' $bname)
	local pcol=$(sed -n 's/\t\tcollapsed=\(.*\),/\1/p' $pname)		
	local name=$(basename $base)
	printf "%-15s %6d %6d %6d %6d\n" \
	       $name $cands $acol $bcol $pcol
}
	
main $@
exit $?
