include ../params.mk

TASKSETS := $(shell find ../tasksets -name "*.dts")
SCHED_TARGETS := \
  $(foreach c, $(CORES), \
    $(patsubst %.dts,%-cores-$(c).sched,$(notdir $(TASKSETS))))

%.sched: cores=$(shell echo $* | sed -E 's/.*-cores-([0-9]+)/\1/')
%.sched: source=$(shell echo $* | sed -E 's/(.*)-cores.*/\1.dts/')
%.sched:
	dts-sched -w -m $(cores) ../tasksets/$(source) -o $@ -t $(TIMEOUT)

all: $(SCHED_TARGETS) sched.dat

sched.dat: $(SCHED_TARGETS)
	../bash/sched-summary.sh

clean:
	find . -name "*.sched" -delete
	rm -f *.dat
