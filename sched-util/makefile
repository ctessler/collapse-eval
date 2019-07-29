all: util-sum-by-cores.dat

util-sum-by-cores.dat: ../sched/util.dat
	../bash/util-sum-by-cores.pl ../sched/util.dat > util-sum-by-cores.dat

clean:
	rm -f util-sum-by-cores.dat


