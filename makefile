include params.mk
# MAKEFLAGS += --jobs=$(JOBS)

dirs=\
  shape demand period deadline trim utils tasksets \
  sched data sched-util\
  plot
.PHONY: all $(dirs)

all: $(dirs)

plot: data sched-util
sched-util: sched
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
clean:
	cd plot ; make clean 
	find . -name "*.cand" -delete
	find . -name "*.csv" -delete
	find . -name "*.dat" -delete
	find . -name "*.dot" -delete
	find . -name "*.dts" -delete
	find . -name "*.list" -delete
	find . -name "*.log" -delete
	find . -name "*.util" -delete


