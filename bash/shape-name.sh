#!/bin/bash
contdir="`dirname \"$0\"`"
source ${contdir}/params.sh
source ${contdir}/funcs.sh

function usage {
	cat <<EOF
shape-name.sh <NODES> <EDGEP> <ITER>
Gives the name of a shape file where
	<NODES>: is the number of nodes in the shape
	<EDGEP>: is the edge probability between any two nodes
	<ITER> : is the iteration of <NODES> and <EDGEP> 
EOF
	exit 1;
}
declare nodes=$1;
declare edgep=$2;
declare count=$3;

if [[ -z "$nodes" || -z $edgep || -z $count ]] ; then
	usage;
fi
   
declare name=$(shape_name $nodes $edgep $count)
echo $name
