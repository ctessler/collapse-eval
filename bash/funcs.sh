# Shared functions

#
# Increase the GNU Scientific Library Seed
#
# This needs to be invoked before every binary that utilizes GSL for
# random sources.
#
function inc_seed {
	if [ -z $GSL_RNG_SEED ] ; then
		GSL_RNG_SEED=`date +%s`
	else
		((GSL_RNG_SEED++))
	fi
	export GSL_RNG_SEED
}

declare -A OSECT
function begin_osect {
	OSECT[pfx]="$1"
	OSECT[maxc]=$(tput cols)
	OSECT[plen]=${#1}
	OSECT[col]=${#1}

	printf "%s" "${OSECT[pfx]}"

}

function add_o {
	local msg="$*"
	local len=${#msg}
	local wlen=$(( OSECT[col] + len ))
	if [[ "${OSECT[maxc]}" -lt "$wlen" ]] ; then
		msg=$(printf "%s%s" "${OSECT[pfx]}" "$msg")
		printf "\n%s" "$msg"
		OSECT[col]=${#msg}
	else
		printf "%s" "$msg"
		OSECT[col]=$(( OSECT[col] + len ))
	fi
}

function newl_o {
	printf "\n";
	begin_osect ${OSECT[pfx]}
}

function end_osect {
	OSECT[pfx]=''
	echo ""
}

declare -A FJOBS
FJOBS[forked]=0
FJOBS[done]=0
function job_submit {
	local cmd=$1;

	if (( FJOBS[forked] >= JOBS )) ; then
		job_wait
	fi
	inc_seed
	$cmd &
	(( FJOBS[forked]++ ))
}

function job_wait {
	wait -n
	#
	# dts-sched-li returns failure if the taskset isn't
	# schedulable, checking the exit status here does not work
	#
	(( FJOBS[forked]-- ))
	(( FJOBS[done]++ ))
}

function job_drain {
	while (( FJOBS[forked] > 0 ))
	do
		job_wait
	done
}

#
# Elapsed
#
# secs=$(elapsed $start)
#
function sec_elapsed {
	local start=$1
	local now=$(date +%s)
	local lapsed=$(( now - start ))

	echo $lapsed
}

#
# Minutes elapsed
#
# min=$(elapsed $start)
function min_elapsed {
	local start=$1
	local secs=$(sec_elapsed $start)
	if [[ 0 -eq $secs ]] ; then
	   printf "%.2f" 0
	   return
	fi
	local mins=$(echo "($secs / 60)" | bc -l)

	printf "%.2f" $mins
	
}

#
# Percent Complete
#
# pct=$(pcomplete $total $current)
#
function pcomplete {
	local total=$1;
	local cur=$2;
	local frac=$(echo "($cur / $total) * 100" | bc -l)

	printf "%.2f" $frac
}


#
# Minutes Remaining (estimate)
#
# mleft=$(min_left $pct_complete $start)
#
function min_remain {
	local pct=$1;
	local start=$2;
	local lapsed=$(min_elapsed $start)
	if [[ "0.00" == $pct ]] ; then
		printf "???"
		return
	fi

	local rem=$(echo "(((100 * $lapsed ) / $pct) - $lapsed)" | bc -l)

	printf "%.2f" $rem
}

# Counts the number of shapes
function shapec {
	local len=${#NODES[@]}
	local count=$len

	len=${#EDGEP[@]}
	count=$(( count * len ))
	count=$(( count * $SCNT ))

	echo $count
}


function demandc {
	local count=$(shapec)
	local objs=${#OBJS[@]}
	local f=${#GROWF[@]}
	

	count=$(( count * objs * f))

	echo $count
}

function periodc {
	local count=$(demandc)
	local u=${#UTILS[@]}

	count=$(( count * u ))

	echo $count
}

function deadlinec {
	periodc
}

# Name functions
function form_name {
	local n=$(printf "%02d" $1); shift
	echo -n "n$n"
	local e=$(printf "%.2f" $1); shift
	echo -n "_e$e"
	local c=$(printf "%03d" $1); shift
	echo -n "_c$c"

	if [[ -z $1 ]] ; then
		return;
	fi
	local o=$(printf "%02d" $1); shift
	echo -n "_o$o"

	if [[ -z $1 ]] ; then
		return;
	fi
	local f=$(printf "%.2f" $1); shift
	echo -n "_f$f"

	if [[ -z $1 ]] ; then
		return;
	fi
	local u=$(printf "%.2f" $1); shift
	echo -n "_u$u"

}

# Names a task file by the shape parameters
function shape_name {
	local nodes=$1
	local edgep=$2
	local count=$3

	local name=$(form_name $nodes $edgep $count)
	echo "$name.dot"
}

function demand_name {
	local nodes=$1
	local edgep=$2
	local count=$3
	local obj=$4
	local f=$5

	local name=$(form_name $nodes $edgep $count $obj $f)
	echo "$name.dot"
}

function period_name {
	local nodes=$1
	local edgep=$2
	local count=$3
	local obj=$4
	local f=$5
	local u=$5	

	local name=$(form_name $nodes $edgep $count $obj $f $u)
	echo "$name.dot"
}

function deadline_name {
	period_name $*
}
