#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

declare LOG=core-savings.log
declare START=$(date +%s)
declare TASKSETS=0

# False entrypoint
function main {
	report

	local n
	rm -f unsorted.util
	rm -f sorted.util

	local ifile=save.dat
	TASKSETS=$(wc -l $ifile | awk '{print $1}')
	begin_osect "CORE SAVINGS[$TASKSETS] "

	local mhnc_avg=$(avg_col $ifile 3)
	local mha_avg=$(avg_col $ifile 4)
	local mhb_avg=$(avg_col $ifile 5)
	local mhp_avg=$(avg_col $ifile 6)		

	local mlnc_avg=$(avg_col $ifile 7)	
	local mla_avg=$(avg_col $ifile 8)
	local mlb_avg=$(avg_col $ifile 9)
	local mlp_avg=$(avg_col $ifile 10)		
	
	local avgs=core-avgs.dat
	printf "# Average number of cores\n" > $avgs
	printf "#%12s %13s %13s\n" "Hueristic" "(avg. m_high)" \
	       "(avg. m_low)" >> $avgs
	printf "%13s %13.2f %13.2f\n" No-Collapse $mhnc_avg $mlnc_avg >> $avgs
	printf "%13s %13.2f %13.2f\n" Arbitrary $mha_avg $mla_avg >> $avgs
	printf "%13s %13.2f %13.2f\n" Max-Ben. $mhb_avg $mlb_avg >> $avgs
	printf "%13s %13.2f %13.2f\n" Min-Pen. $mhp_avg $mlp_avg >> $avgs

	local mha_adiff=$(echo $mhnc_avg - $mha_avg | bc -l)
	local mla_adiff=$(echo $mlnc_avg - $mla_avg | bc -l)	
	local mhb_adiff=$(echo $mhnc_avg - $mhb_avg | bc -l)	
	local mlb_adiff=$(echo $mlnc_avg - $mlb_avg | bc -l)
	local mhp_adiff=$(echo $mhnc_avg - $mhp_avg | bc -l)	
	local mlp_adiff=$(echo $mlnc_avg - $mlp_avg | bc -l)
	
	local sum=core-save.dat
	printf "# Average number of cores saved\n" > $sum
	printf "#%12s %13s %13s\n" "Hueristic" "(avg. m_high)" \
	       "(avg. m_low)" >> $sum
	printf "%13s %13.2f %13.2f\n" Arbitrary $mha_adiff $mla_adiff >> $sum
	printf "%13s %13.2f %13.2f\n" Max-Ben. $mhb_adiff $mlb_adiff >> $sum
	printf "%13s %13.2f %13.2f\n" Min-Pen. $mhp_adiff $mlp_adiff >> $sum

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

function avg_col {
	local file=$1; shift;
	local col=$1; shift

	local sum=$(awk "{s+=\$$col} END {print s}" $file)
	local avg=$(echo "$sum / $TASKSETS" | bc -l)

	echo $avg
}


function cp_data {
	local base=$1
	local aname=$(echo $base | sed s/\.dts/-a.dts/)
	local bname=$(echo $base | sed s/\.dts/-b.dts/)
	local pname=$(echo $base | sed s/\.dts/-p.dts/)		

	local nclen=$(sum_cpathlen $base)
	local aclen=$(sum_cpathlen $aname)
	local deltaa deltab deltap
	(( deltaa = aclen - nclen ))
	local bclen=$(sum_cpathlen $bname)
	(( deltab = bclen - nclen ))
	local pclen=$(sum_cpathlen $pname)
	(( deltap = pclen - nclen ))

	local name=$(basename $base)
	printf "%-15s %6d %6d %6d %6d %6d %6d %6d\n" \
	       $name $nclen $aclen $bclen $pclen $deltaa $deltab $deltap
}

function sum_cpathlen {
	local file=$1

	local cmd="dts-print ../tasksets/$file"
	local v
	local clen=0
	while read -r v
	do
		local c=$(echo $v | grep -v \# | awk '{print $5}')
		(( clen += c ))
	done < <($cmd)

	echo $clen
}
	
main
exit $?
