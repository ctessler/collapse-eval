all: done sched-sum.dat util-sum.dat cp-delta.dat wl-delta.dat

wl-delta.dat: done
	../bash/wl-save.sh 

cp-delta.dat: done
	../bash/cp-diff.sh 

util-sum.dat: done
	../bash/util-sum.pl util.dat > util-sum.dat

sched-sum.dat: done
	../bash/sched-sum.sh > sched-sum.dat
done:
	../bash/data.sh
	touch done

clean:
	rm -f done *.list *.csv *.dat *.log


