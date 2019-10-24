all: sched-sum.dat util-sum.dat \
    cand-collapse.dat core-savings.dat \
    cp-delta-pt.dat wl-delta-pt.dat

core-savings.dat:  ../sched/save.dat
	../bash/core-savings.sh ../sched/save.dat

cand-collapse.dat:
	../bash/cand-collapse.sh 

wl-delta-pt.dat:
	../bash/wl-save-per-task.sh

cp-delta-pt.dat:
	../bash/cp-diff-per-task.sh

util-sum.dat: ../sched/util.dat
	../bash/util-sum.pl ../sched/util.dat > util-sum.dat

sched-sum.dat: ../sched/sched.dat
	../bash/sched-sum.sh ../sched/sched.dat > sched-sum.dat

clean:
	rm -f done *.list *.csv *.dat *.log


