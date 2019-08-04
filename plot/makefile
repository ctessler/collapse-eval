# .NOTPARALLEL: # Don't know why this doesn't work probably because of latexmk

%.tex: %.p
	gnuplot $<

%.pdf: %.tex
	latexmk -pdf $< $@
	latexmk -c $<
	rm -f $*-inc*eps*

util-vs-sched-int-%.pdf: ifile = ../intervals/util-int-$*.dat
util-vs-sched-int-%.pdf: ofile = util-vs-sched-int-$*.tex
util-vs-sched-int-%.pdf:
	gnuplot -e "ifile='$(ifile)'; ofile='$(ofile)'; int=$*" util-vs-sched-int-ci.p
	latexmk -pdf $(ofile)
	latexmk -c $(ofile)
	rm $(ofile)
	rm util-vs-sched-int-$*-inc*

INTERVALS=1 2 3 4 5 
INT_TARGETS= \
  $(foreach n, $(INTERVALS), $(addsuffix $(n).pdf, util-vs-sched-int-))


all: cand-collapse.pdf cand-percent.pdf util-vs-sched.pdf \
	wl-avgs.pdf wl-save.pdf \
	cp-avgs.pdf cp-extend.pdf \
	core-save-high.pdf core-avgs-high.pdf \
	core-save-low.pdf core-avgs-low.pdf \
	util-vs-sched-cores-2.pdf \
	util-vs-sched-cores-4.pdf \
	util-vs-sched-cores-8.pdf \
	util-vs-sched-cores-12.pdf \
	util-vs-sched-cores-16.pdf \
	util-vs-sched-cores-20.pdf \
	util-vs-sched-cores-24.pdf \
	util-vs-sched-cores-28.pdf \
	util-vs-sched-cores-32.pdf \
	$(INT_TARGETS) \

clean:
	rm -f done *.list *.csv *.dat *.log *.tex *.pdf *.eps *.aux
	rm -f *.fdb_latexmk *.fls


