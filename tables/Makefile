.PHONY: all clean balance complexity

all: balance complexity

clean:
	$(RM) -R compiled output

balance: output/bal_distances.tex output/bal_misc.tex output/bal_balance.tex output/bal_rmse.tex

complexity: output/comp_small_cpu.pdf output/comp_medium_cpu.pdf output/comp_big_cpu.pdf output/comp_small_mem.pdf output/comp_medium_mem.pdf output/comp_big_mem.pdf output/comp_cputime.tex output/comp_memory.tex

output/bal_%.tex: tables_balance.R compiled/balance.Rdata
	mkdir -p output
	Rscript tables_balance.R

output/comp_%.pdf: figure_complexity.R compiled/complexity.Rdata
	mkdir -p output
	Rscript figure_complexity.R

output/comp_%.tex: tables_complexity.R compiled/complexity.Rdata
	mkdir -p output
	Rscript tables_complexity.R

compiled/balance.Rdata: ../collected/balance.Rdata
	mkdir -p compiled
	Rscript compile_balance.R

compiled/complexity.Rdata: ../collected/complexity.Rdata
	mkdir -p compiled
	Rscript compile_complexity.R
