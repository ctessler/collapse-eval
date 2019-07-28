#!/bin/bash
for dir in trim utils tasksets sched data plot
do
	pushd $dir
	make clean
	popd
done
