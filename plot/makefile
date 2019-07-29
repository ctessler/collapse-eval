.NOTPARALLEL: # Don't know why this doesn't work probably because of latexmk

%.tex: %.p
	gnuplot $<

%.pdf: %.tex
	latexmk -pdf $< $@
	latexmk -c $<
	rm -f *eps*

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
	util-vs-sched-cores-32.pdf

clean:
	rm -f done *.list *.csv *.dat *.log *.tex *.pdf *.eps *.aux
	rm -f *.fdb_latexmk *.fls


