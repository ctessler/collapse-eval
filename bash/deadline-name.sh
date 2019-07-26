#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

function usage {
	cat <<EOF
deadline-name.sh <NODES> <EDGEP> <ITER> <OBJECT> <GROWF> <UTIL> <CPFAC>
Gives the name of a shape file where
        First five parameters are the same as demand-name.sh
	<NODES>: is the number of nodes in the shape
	<EDGEP>: is the edge probability between any two nodes
	<ITER> : is the iteration of <NODES> and <EDGEP> 
	<OBJECT> : count of objects
	<GROWF>  : growth factor
	<UTIL>   : utilization
	<CPFAC>  : critical path length factor
EOF
	exit 1;
}
declare nodes=$1;
declare edgep=$2;
declare count=$3;
declare obj=$4;
declare growf=$5;
declare util=$6;
declare cpf=$7;

if [[ -z "$nodes" || -z "$edgep" || -z "$count" || -z $obj || -z $growf || -z $util || -z $cpf ]] ; then
	usage;
fi
   
declare name=$(deadline_name $nodes $edgep $count $obj $growf $util $cpf)
echo $name
