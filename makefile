dirs=shape demand period deadline
.PHONY: all $(dirs)

all: $(dirs)

$(dirs):
	make -C $@ $(TGT)

clean: TGT=clean
clean: $(dirs)
	rm -f *.log
