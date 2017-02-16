source("funcs_complexity.R")

load("./compiled/complexity.Rdata")

# Time in minutes
compiled_results$tot_time <- compiled_results$tot_time / 60
# Memory in GB
compiled_results$memory <- compiled_results$memory / 1024^2

matching_methods <- c("Greedy 1:1" = "gre_pairmatch",
                      "Optimal 1:1" = "opt_pairmatch",
                      "Replacement 1:1" = "rep_pairmatch",
                      "Greedy 1:2" = "gre_kmatch",
                      "Optimal 1:2" = "opt_kmatch",
                      "Full matching" = "opt_fullmatch",
                      "GFM" = "scclust_LEX_ANY",
                      "Refined GFM" = "scclust_EXU_CSE")

sample_sizes <- c("100" = 1e2,
                  "500" = 5e2,
                  "1K" = 1e3,
                  "5K" = 5e3,
                  "10K" = 10e3,
                  "20K" = 20e3,
                  "50K" = 50e3,
                  "100K" = 10e4,
                  "200K" = 20e4,
                  "500K" = 50e4,
                  "1M" = 10e5,
                  "5M" = 50e5,
                  "10M" = 1e7,
                  "50M" = 5e7,
                  "100M" = 10e7)

table_data <- do.call(rbind, lapply(unname(matching_methods),
                                    function(x) { data.frame(method = x,
                                                             sample_size = unname(sample_sizes),
                                                             stringsAsFactors = FALSE)
                                    }))

table_data <- merge(table_data, compiled_results, all.x = TRUE)


# Table 1: CPU time

make_table("output/comp_cputime.tex",
           table_data,
           matching_methods,
           "tot_time",
           names(sample_sizes))


# Table 2: Memory

make_table("output/comp_memory.tex",
           table_data,
           matching_methods,
           "memory",
           names(sample_sizes))
