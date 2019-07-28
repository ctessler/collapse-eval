#!/bin/bash

declare -a HEURS=(a b p)
declare SCHED=sched.dat
declare INFEAS=infeas.dat
declare SAVE=save.dat
declare UTIL=util.dat

# Output is: 
#	tasks infeas sched m_high m_low   util
declare tasks=0 infeas=1 sched=2 mhigh=3 mlow=4 util=5

# false entry point
function main {
	# SCHEDULABILITY
	echo "# SCHC: SCHEDULABLE without collapse" > $SCHED
	echo "# SCHA: SCHEDULABLE when arbitrary collapsed ... " >> $SCHED
	echo "# SCHB: SCHEDULABLE when max benefit collapsed ... " >> $SCHED
	echo "# SCHP: SCHEDULABLE when min penalty collapsed ... " >> $SCHED
	printf "#%14s %5s %4s %4s %4s %4s\n" TASKSET CORES SCHC SCHA SCHB SCHP >> $SCHED

	# INFEASIBILITY
	echo "# IFNC: INFEASIBLE without any collapse" > $INFEAS
	echo "# IFCA: INFEASIBLE when collapsed by arbitrary" >> $INFEAS
	echo "# IFCB: INFEASIBLE when collapsed by max benefit" >> $INFEAS
	echo "# IFCP: INFEASIBLE when collapsed by min penalty" >> $INFEAS
	printf "#%14s %5s %4s %4s %4s %4s\n" TASKSET CORES IFNC IFCA IFCB IFCP >> $INFEAS

	# CORE SAVINGS
	echo "# MHC: M_HIGH without any collapse " > $SAVE
	echo "# MHA: M_HIGH when arbitrary collapsed ... " >> $SAVE
	echo "# MLC: M_LOW without any collapse " >> $SAVE
	echo "# MLA: M_LOW when arbitrary collapsed ... " >> $SAVE
	printf "#%14s %5s %4s %4s %4s %4s %4s %4s %4s %4s\n" \
	       TASKSET CORES MHC MHA MHB MHP MLC MLA MLB MLP >> $SAVE

	# UTILIZATION SUMMARY
	printf "#%14s %5s\n" TASKSET UTIL > $UTIL
	
	for i in $(find . -name "*.sched" | grep -v '\-[abp]' | sort -n)
	do
		local base=$(echo $i | sed 's/-cores.*/.dts/')
		base=$(echo $base | sed 's/\.\///')
		local cores=$(echo $i | sed 's/.*-cores-\([0-9]\+\).sched/\1/')
		echo "Summarizing $base cores:$cores"

		# SCHEDULING SUMMARY
		printf "%15s %05d" $base $cores >> $SCHED
		printf " %4s" $(sched_val $i) >> $SCHED

		# INFEASIBILITY SUMMARY
		printf "%15s %05d" $base $cores >> $INFEAS
		printf " %4s" $(infeas_val $i) >> $INFEAS

		# CORE SAVINGS SUMMARY
		printf "%15s %05d" $base $cores >> $SAVE
		# MHIGH
		printf " %4s" $(mhigh_val $i) >> $SAVE

		# UTILIZATION
		local u=$(dts-util -L ../tasksets/$base)
		printf "%15s %5.2f\n" $base $u >> $UTIL		
		
		for a in ${HEURS[@]}
		do
			# SCHEDULING SUMMARY
			local hname=$(echo $i | sed "s/-cores/-${a}-cores/")
			echo -e "\t$hname"
			printf " %4s" $(sched_val $hname) >> $SCHED

			# INFEASIBILITY SUMMARY
			printf " %4s" $(infeas_val $hname) >> $INFEAS

			# MHIGH
			printf " %4s" $(mhigh_val $hname) >> $SAVE
		done

		# MLOW
		printf " %4s" $(mlow_val $i) >> $SAVE
		for a in ${HEURS[@]}
		do
			# MHIGH
			printf " %4s" $(mlow_val $hname) >> $SAVE			
			
		done

		printf "\n" >> $SCHED
		printf "\n" >> $INFEAS
		printf "\n" >> $SAVE
	done

}


function sched_val {
	local file=$1; shift;
	local line=$(grep -v \# $file)
	local -a vals=($line)

	echo ${vals[$sched]}
}

function infeas_val {
	local file=$1; shift;
	local line=$(grep -v \# $file)
	local -a vals=($line)

	echo ${vals[$infeas]}
}

function mhigh_val {
	local file=$1; shift;
	local line=$(grep -v \# $file)
	local -a vals=($line)

	echo ${vals[$mhigh]}
}

function mlow_val {
	local file=$1; shift;
	local line=$(grep -v \# $file)
	local -a vals=($line)

	echo ${vals[$mlow]}
}

main $@
exit $?
