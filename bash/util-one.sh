#!/bin/bash

declare file=$1
if [[ -z "$file" ]] ; then
	echo "A file is required"
	echo "	util-one.sh <FILE>"
	exit 1
fi

# False entrypoint
function main {
	local file=$1;

	local util=$(dts-util $file)
	if [[ $? -ne 0 ]]
	then
		echo "Error!"
		exit -1
	fi

	local base=$(basename $file)
	printf "%02.3f %s\n" $util $base
}

main $file
exit $?
