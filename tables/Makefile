.PHONY: all clean balance complexity

all: balance complexity

clean:
	$(RM) -fR ./compiled ./output

balance: ./output ./compiled/balance.Rdata
	Rscript tables_balance.R

complexity: ./output ./compiled/complexity.Rdata
	Rscript figure_complexity.R
	Rscript tables_complexity.R

./compiled/balance.Rdata: ./compiled ../collected/balance.Rdata
	Rscript compile_balance.R

./compiled/complexity.Rdata: ./compiled ../collected/complexity.Rdata
	Rscript compile_complexity.R

./compiled:
	mkdir -p ./compiled

./output:
	mkdir -p ./output
