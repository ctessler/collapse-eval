dirs=shape demand period deadline trim utils tasksets
.PHONY: all $(dirs)

all: $(dirs)

tasksets: utils
utils: trim
trim: deadline
deadline: period
period: demand
demand: shape


$(dirs):
	make -C $@ $(TGT)

clean: TGT=clean
clean: $(dirs)
	rm -f *.log
