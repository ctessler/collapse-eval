#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

function usage {
	cat <<EOF
demand-name.sh <NODES> <EDGEP> <ITER> <OBJECT> <GROWF>
Gives the name of a shape file where
        First three parameters are the same as shape-name.sh
	<NODES>: is the number of nodes in the shape
	<EDGEP>: is the edge probability between any two nodes
	<ITER> : is the iteration of <NODES> and <EDGEP> 
	<OBJECT> : count of objects
	<GROWF>  : growth factor
EOF
	exit 1;
}
declare nodes=$1;
declare edgep=$2;
declare count=$3;
declare obj=$4;
declare growf=$5;

if [[ -z "$nodes" || -z "$edgep" || -z "$count" || -z $obj || -z $growf ]] ; then
	usage;
fi
   
declare name=$(demand_name $nodes $edgep $count $obj $growf)
echo $name
