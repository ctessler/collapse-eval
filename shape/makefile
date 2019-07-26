include ../params.mk

ITER := $(shell seq 1 $(GRAFC))
TARGETS := $(foreach n, $(NODES), \
		$(foreach e, $(EDGEP), \
			$(addprefix targetn$(n)e$(e)s, $(ITER))))


all: $(TARGETS) $(MAKEFLAGS)

target%: nodes=$(shell echo $* | sed -E 's/n([0-9]+).*/\1/')
target%: edgep=$(shell echo $* | sed -E 's/.*e([0-9]+\.[0-9]+).*/\1/')
target%: count=$(shell echo $* | sed -E 's/.*s([0-9]+).*/\1/')
target%: ofile=$(shell ../bash/shape-name.sh $(nodes) $(edgep) $(count))
target%:
	dts-gen-nodes -n $(nodes) -e $(edgep) -o $(ofile)

clean:
	rm -f done shapes.log *.dot


