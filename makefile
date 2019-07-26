include params.mk
MAKEFLAGS += --jobs=$(JOBS)

dirs=shape demand period deadline trim utils tasksets data plot
.PHONY: all $(dirs)

all: $(dirs)

plot: data
data: tasksets
tasksets: utils
utils: trim
trim: deadline
deadline: period
period: demand
demand: shape

$(dirs):
	$(MAKE) -C $@ $(TGT)

clean: TGT=clean
clean: $(dirs)
	rm -f *.log
