include ../params.mk

ITER := $(shell seq 1 $(GRAFC))
TARGETS := \
  $(foreach n, $(NODES), \
    $(foreach e, $(EDGEP), \
      $(foreach c, $(ITER), \
        $(foreach o, $(OBJS), \
          $(foreach f, $(GROWF), \
            $(shell ../bash/demand-name.sh $(n) $(e) $(c) $(o) $(f)))))))

all: $(TARGETS)

%.dot: nodes=$(shell echo $* | sed -E 's/n([0-9]+).*/\1/')
%.dot: edgep=$(shell echo $* | sed -E 's/.*e([0-9]+\.[0-9]+).*/\1/')
%.dot: count=$(shell echo $* | sed -E 's/.*c([0-9]+).*/\1/')
%.dot: obj=$(shell echo $* | sed -E 's/.*o([0-9]+).*/\1/')
%.dot: growf=$(shell echo $* | sed -E 's/.*f([0-9]+\.[0-9]+).*/\1/')
%.dot: ifile=$(shell ../bash/shape-name.sh $(nodes) $(edgep) $(count))
%.dot:
	dts-demand -t ../shape/$(ifile) -w $(WCET1) -j $(obj) -f $(growf) \
	    -o $@

clean:
	find . -name "*.dot" -delete


