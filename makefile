include params.mk
# MAKEFLAGS += --jobs=$(JOBS)

dirs=\
  shape demand period deadline trim utils tasksets \
  sched data \
  plot
.PHONY: all $(dirs)

all: $(dirs)

plot: data 
data: sched
sched: tasksets
tasksets: utils
utils: trim
trim: deadline
deadline: period
period: demand
demand: shape

$(dirs):
	$(MAKE) -C $@ $(TGT)

#
# If the parameters are updated, run this first
#     > make new-params
#
new-params:
	bash/new-params.sh

clean: TGT=clean
clean: $(dirs)
	rm -f *.log
