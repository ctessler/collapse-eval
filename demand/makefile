include ../params.mk

ITER := $(shell seq 1 $(GRAFC))
TARGETS := \
  $(foreach n, $(NODES), \
    $(foreach e, $(EDGEP), \
      $(foreach c, $(ITER), \
        $(foreach o, $(OBJS), \
	  $(addprefix targetn$(n)e$(e)c$(c)o$(o)f, $(GROWF))))))


all: $(TARGETS) 

target%: nodes=$(shell echo $* | sed -E 's/n([0-9]+).*/\1/')
target%: edgep=$(shell echo $* | sed -E 's/.*e([0-9]+\.[0-9]+).*/\1/')
target%: count=$(shell echo $* | sed -E 's/.*c([0-9]+).*/\1/')
target%: obj=$(shell echo $* | sed -E 's/.*o([0-9]+).*/\1/')
target%: growf=$(shell echo $* | sed -E 's/.*f([0-9]+\.[0-9]+).*/\1/')
target%: ifile=$(shell ../bash/shape-name.sh $(nodes) $(edgep) $(count))
target%: ofile=$(shell ../bash/demand-name.sh $(nodes) $(edgep) $(count) $(obj) $(growf))
target%:
	dts-demand -t ../shape/$(ifile) -w $(WCET1) -j $(obj) -f $(growf) -o $(ofile)

clean:
	rm -f done *.log *.dot


