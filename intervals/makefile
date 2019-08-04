

util-int-%.dat: ../data/util-sum.dat
	../bash/intervals.sh ../data/util-sum.dat $* > $@

all: util-int-1.dat util-int-2.dat util-int-3.dat util-int-4.dat util-int-5.dat

clean:
	rm *.dat
