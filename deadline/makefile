include ../params.mk

ITER := $(shell seq 1 $(GRAFC))
TARGETS := \
  $(foreach n, $(NODES), \
    $(foreach e, $(EDGEP), \
      $(foreach c, $(ITER), \
        $(foreach o, $(OBJS), \
          $(foreach f, $(GROWF), \
            $(foreach u, $(UTILS), \
              $(addprefix targetn$(n)e$(e)c$(c)o$(o)f$(f)u$(u)a, $(CPFAC))))))))


all: $(TARGETS) 

target%: nodes=$(shell echo $* | sed -E 's/n([0-9]+).*/\1/')
target%: edgep=$(shell echo $* | sed -E 's/.*e([0-9]+\.[0-9]+).*/\1/')
target%: count=$(shell echo $* | sed -E 's/.*c([0-9]+).*/\1/')
target%: obj=$(shell echo $* | sed -E 's/.*o([0-9]+).*/\1/')
target%: growf=$(shell echo $* | sed -E 's/.*f([0-9]+\.[0-9]+).*/\1/')
target%: util=$(shell echo $* | sed -E 's/.*u([0-9]+\.[0-9]+).*/\1/')
target%: cpf=$(shell echo $* | sed -E 's/.*a([0-9]+\.[0-9]+).*/\1/')
target%: ifile=$(shell ../bash/period-name.sh $(nodes) $(edgep) $(count) $(obj) $(growf) $(util))
target%: ofile=$(shell ../bash/deadline-name.sh $(nodes) $(edgep) $(count) $(obj) $(growf) $(util) $(cpf))
target%:
	dts-deadline -t ../period/$(ifile) -o $(ofile) -c $(cpf)

clean:
	rm -f done *.log *.dot




