#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

declare LOG=data.log
declare START=$(date +%s)
declare INFEAS=infeas.dat	# infeasibility data
declare SCHED=sched.dat		# schedulability data
declare SAVE=save.dat		# core allocation savings
declare COLL=coll.dat		# collapse data
declare UTIL=util.dat		# utilization data

declare TASKSETS=0
# False entrypoint
function main {
	report

	find ../tasksets -name "*.dts" | grep -v '\-[abp]' | sort -n > base.list
	TASKSETS=$(wc -l base.list | awk '{print $1}')
	begin_osect "DATA[$TASKSETS]"

	echo "# IFNC: INFEASIBLE without any collapse" > $INFEAS
	echo "# IFCA: INFEASIBLE when collapsed by arbitrary" >> $INFEAS
	echo "# IFCB: INFEASIBLE when collapsed by max benefit" >> $INFEAS
	echo "# IFCP: INFEASIBLE when collapsed by min penalty" >> $INFEAS
	printf "#%14s %5s %4s %4s %4s %4s\n" TASKSET CORES IFNC IFCA IFCB IFCP >> $INFEAS

	echo "# SCHC: SCHEDULABLE without collapse" > $SCHED
	echo "# SCHA: SCHEDULABLE when arbitrary collapsed ... " >> $SCHED
	echo "# SCHB: SCHEDULABLE when max benefit collapsed ... " >> $SCHED
	echo "# SCHP: SCHEDULABLE when min penalty collapsed ... " >> $SCHED
	printf "#%14s %5s %4s %4s %4s %4s\n" TASKSET CORES SCHC SCHA SCHB SCHP >> $SCHED

	echo "# CAND: Number of candidates " > $COLL
	echo "# COLA: COLLAPSED by arbitrary " >> $COLL
	echo "# COLB: COLLAPSED by max benefit " >> $COLL
	echo "# COLP: COLLAPSED by min penalty " >> $COLL
	printf "#%14s %5s %4s %4s %4s %4s\n" \
	       TASKSET CORES CAND COLA COLB COLP >> $COLL

	echo "# MHC: M_HIGH without any collapse " > $SAVE
	echo "# MHA: M_HIGH when arbitrary collapsed ... " >> $SAVE
	echo "# MLC: M_LOW without any collapse " >> $SAVE
	echo "# MLA: M_LOW when arbitrary collapsed ... " >> $SAVE
	printf "#%14s %5s %4s %4s %4s %4s %4s %4s %4s %4s\n" \
	       TASKSET CORES MHC MHA MHB MHP MLC MLA MLB MLP >> $SAVE

	printf "#%14s %5s\n" TASKSET UTIL > $UTIL
	

	local line
	while read -r line
	do
		add_o +u
		job_submit "util_data $line"
		add_o -u
		
		local c
		for c in ${CORES[*]}
		do
			add_o +$c
			job_submit "base_data $line $c"
			add_o -$c
		done
	done < base.list
	exit

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

function base_data {
	local base=$1;
	local cores=$2;

	local aname=$(echo "$base" | sed 's/\.dts/-a.dts/')
	local bname=$(echo "$base" | sed 's/\.dts/-b.dts/')
	local pname=$(echo "$base" | sed 's/\.dts/-p.dts/')

	# Output is: 
	#	tasks infeas sched m_high m_low   util
	local short=$(basename $base)
	local tasks=0 infeas=1 sched=2 mhigh=3 mlow=4 util=5

	local cmd="dts-sched -w -m $cores $base"
	echo $cmd >> $LOG
	local out=$($cmd | grep -v \#)
	local -a basevals=($out)

	cmd="dts-sched -w -m $cores $aname"
	echo $cmd >> $LOG	
	out=$($cmd | grep -v \#)	
	local -a avals=($out)

	cmd="dts-sched -w -m $cores $bname"
	echo $cmd >> $LOG	
	out=$($cmd | grep -v \#)	
	local -a bvals=($out)

	cmd="dts-sched -w -m $cores $pname"
	echo $cmd >> $LOG	
	out=$($cmd | grep -v \#)	
	local -a pvals=($out)

	printf "%15s %05d %4s %4s %4s %4s\n" \
	       $short $cores ${basevals[$infeas]} ${avals[$infeas]} ${bvals[$infeas]} \
	       ${pvals[$infeas]} >> $INFEAS	

	printf "%15s %05d %4s %4s %4s %4s\n" \
	       $short $cores ${basevals[$sched]} ${avals[$sched]} ${bvals[$sched]} \
	       ${pvals[$sched]} >> $SCHED	

	
	printf "%15s    %02d %4d %4d %4d %4d %4d %4d %4d %4d\n" \
	       $short $cores \
	       ${basevals[$mhigh]} ${avals[$mhigh]} ${bvals[$mhigh]} ${pvals[$mhigh]} \
	       ${basevals[$mlow]} ${avals[$mlow]} ${bvals[$mlow]} ${pvals[$mlow]} >> $SAVE
}

function util_data {
	local base=$1
	local cmd="dts-util -L $base"
	echo $cmd >> $LOG
	out=$($cmd)

	local short=$(basename $base)	
	printf "%15s %5.2f\n" $short $out >> $UTIL
}	

main
exit $?

