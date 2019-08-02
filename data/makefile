all: sched-sum.dat util-sum.dat cp-delta.dat wl-delta.dat \
    cand-collapse.dat core-savings.dat

core-savings.dat:  ../sched/save.dat
	../bash/core-savings.sh ../sched/save.dat

cand-collapse.dat:
	../bash/cand-collapse.sh 

wl-delta.dat:
	../bash/wl-save.sh 

cp-delta.dat:
	../bash/cp-diff.sh 

util-sum.dat: ../sched/util.dat
	../bash/util-sum.pl ../sched/util.dat > util-sum.dat

sched-sum.dat: ../sched/sched.dat
	../bash/sched-sum.sh ../sched/sched.dat > sched-sum.dat

clean:
	rm -f done *.list *.csv *.dat *.log


