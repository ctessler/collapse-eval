%.tex: %.p
	gnuplot $<

%.pdf: %.tex
	latexmk -pdf $< $@
	latexmk -c $<
	rm -f *eps*

all: cand-collapse.pdf cand-percent.pdf util-vs-sched.pdf \
	wl-avgs.pdf wl-save.pdf \
	cp-avgs.pdf cp-extend.pdf

# util-vs-sched.pdf: util-vs-sched.p
# 	gnuplot util-vs-sched.p
# 	pdflatex util-vs-sched.tex

done:
	../bash/data.sh
	touch done

clean:
	rm -f done *.list *.csv *.dat *.log *.tex *.pdf *.eps *.aux


