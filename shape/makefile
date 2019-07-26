include ../params.mk

ITER := $(shell seq 1 $(GRAFC))
TARGETS := \
  $(foreach n, $(NODES), \
    $(foreach e, $(EDGEP), \
      $(foreach c, $(ITER), \
        $(shell ../bash/shape-name.sh $(n) $(e) $(c)))))



all: $(TARGETS) 

%.dot: nodes=$(shell echo $* | sed -E 's/n([0-9]+).*/\1/')
%.dot: edgep=$(shell echo $* | sed -E 's/.*e([0-9]+\.[0-9]+).*/\1/')
%.dot: count=$(shell echo $* | sed -E 's/.*c([0-9]+).*/\1/')
%.dot: ofile=$(shell ../bash/shape-name.sh $(nodes) $(edgep) $(count))
%.dot:
	dts-gen-nodes -n $(nodes) -e $(edgep) -o $@

clean:
	rm -f done shapes.log *.dot


