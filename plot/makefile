# .NOTPARALLEL: # Don't know why this doesn't work probably because of latexmk
include ../params.mk

INTERVALS=1 2 3 4 5 
INT_TARGETS= \
  $(foreach n, $(INTERVALS), $(addsuffix $(n).pdf, util-vs-sched-int-))

INT_CORE_TARGETS = \
  $(foreach c, $(CORES), \
    $(foreach n, $(INTERVALS), \
      $(addsuffix $(n).pdf, util-vs-sched-cores-$(c)-int-)))

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

util-vs-sched-cores-%.pdf: cores=$(shell echo $* | sed 's/\(.*\)-int-.*/\1/')
util-vs-sched-cores-%.pdf: int=$(shell echo $* | sed 's/.*-int-//')
util-vs-sched-cores-%.pdf: ifile = ../intervals/util-cores-$(cores)-int-$(int).dat
util-vs-sched-cores-%.pdf: ofile = util-vs-sched-cores-$(cores)-int-$(int).tex
util-vs-sched-cores-%.pdf:
	gnuplot -e "ifile='$(ifile)'; ofile='$(ofile)'; cores=$(cores); int=$(int)" \
	    util-vs-sched-cores-int.p
	latexmk -pdf $(ofile)
	latexmk -c $(ofile)
	rm $(ofile)
	rm util-vs-sched-cores-$*-inc*


all: cand-collapse.pdf cand-percent.pdf util-vs-sched.pdf \
	wl-avgs.pdf wl-save.pdf \
	cp-avgs.pdf cp-extend.pdf \
	core-save-high.pdf core-avgs-high.pdf \
	core-save-low.pdf core-avgs-low.pdf \
	$(INT_TARGETS) \
	$(INT_CORE_TARGETS)

clean:
	rm -f done *.list *.csv *.dat *.log *.tex *.pdf *.eps *.aux
	rm -f *.fdb_latexmk *.fls


