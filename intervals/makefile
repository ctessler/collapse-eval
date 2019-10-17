include ../params.mk
INTERVALS=1 2 3 4 5 

INT_TARGETS= \
  $(foreach n, $(INTERVALS), $(addsuffix $(n).dat, util-int-))

INT_CORE_TARGETS = \
  $(foreach c, $(CORES), \
    $(foreach n, $(INTERVALS), \
      $(addsuffix $(n).dat, util-cores-$(c)-int-)))

util-int-%.dat: ../data/util-sum.dat
	@echo ../bash/intervals.sh ../data/util-sum.dat $* > $@
	../bash/intervals.sh ../data/util-sum.dat $* > $@

util-cores-%.dat: cores=$(shell echo $* | sed 's/\(.*\)-int-.*/\1/')
util-cores-%.dat: int=$(shell echo $* | sed 's/.*-int-//')
util-cores-%.dat: ../sched-util/util-sum-by-cores.dat
	../bash/intervals-by-core.sh ../sched-util/util-sum-by-cores.dat \
            $(int) $(cores) > $@

all: $(INT_TARGETS) $(INT_CORE_TARGETS) 

clean:
	rm *.dat
