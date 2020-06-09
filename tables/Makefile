.PHONY: all clean balance complexity

BALANCE_TABLES = output/bal_app_bal.tex \
                 output/bal_app_dist.tex \
                 output/bal_app_group.tex \
                 output/bal_app_rmse.tex \
                 output/bal_main_bal_rmse.tex

COMPLEXITY_TABLES = output/comp_cputime.tex \
                    output/comp_memory.tex

COMPLEXITY_FIGURES = output/comp_big_cpu.pdf \
                     output/comp_big_mem.pdf \
                     output/comp_medium_cpu.pdf \
                     output/comp_medium_mem.pdf \
                     output/comp_small_cpu.pdf \
                     output/comp_small_mem.pdf

all: balance complexity

clean:
	$(RM) -R compiled output

balance: $(BALANCE_TABLES)

complexity: $(COMPLEXITY_TABLES) $(COMPLEXITY_FIGURES)

output/bal_%.tex: tables_balance.R funcs_balance.R compiled/balance.Rdata
	mkdir -p output
	Rscript tables_balance.R

output/comp_%.pdf: figure_complexity.R funcs_complexity.R compiled/complexity.Rdata
	mkdir -p output
	Rscript figure_complexity.R

output/comp_%.tex: tables_complexity.R funcs_complexity.R compiled/complexity.Rdata
	mkdir -p output
	Rscript tables_complexity.R

compiled/balance.Rdata: compile_balance.R ../collected/balance.Rdata
	mkdir -p compiled
	Rscript compile_balance.R

compiled/complexity.Rdata: compile_complexity.R ../collected/complexity.Rdata
	mkdir -p compiled
	Rscript compile_complexity.R
