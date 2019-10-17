include ../params.mk
RNGSEED := $(shell date +%s)

ITER := $(shell seq 1 $(GRAFC))
TARGETS := \
  $(foreach n, $(NODES), \
    $(foreach e, $(EDGEP), \
      $(foreach c, $(ITER), \
        $(foreach o, $(OBJS), \
          $(foreach f, $(GROWF), \
            $(foreach u, $(UTILS), \
              $(foreach a, $(CPFAC), \
                $(shell ../bash/deadline-name.sh \
                  $(n) $(e) $(c) $(o) $(f) $(u) $(a)))))))))

all: $(TARGETS) 

%.dot: nodes=$(shell echo $* | sed -E 's/n([0-9]+).*/\1/')
%.dot: edgep=$(shell echo $* | sed -E 's/.*e([0-9]+\.[0-9]+).*/\1/')
%.dot: count=$(shell echo $* | sed -E 's/.*c([0-9]+).*/\1/')
%.dot: obj=$(shell echo $* | sed -E 's/.*o([0-9]+).*/\1/')
%.dot: growf=$(shell echo $* | sed -E 's/.*[^p]f([0-9]+\.[0-9]+).*/\1/')
%.dot: util=$(shell echo $* | sed -E 's/.*u([0-9]+\.[0-9]+).*/\1/')
%.dot: cpf=$(shell echo $* | sed -E 's/.*cpf([0-9]+\.[0-9]+).*/\1/')
%.dot: ifile=$(shell ../bash/period-name.sh $(nodes) $(edgep) $(count) $(obj) $(growf) $(util))
%.dot:
	$(eval RNGSEED=$(shell echo $(RNGSEED) + 1 | bc))
	@echo "dts-deadline -i -t ../period/$(ifile) -o $@" >> deadline.log
	GSL_RNG_SEED=$(RNGSEED) dts-deadline -i -t ../period/$(ifile) -o $@

clean:
	find . -name "*.dot" -delete
	rm -rf *.log




