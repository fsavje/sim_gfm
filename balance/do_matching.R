args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 2) {
  match_fun <- args[1]
  data_set <- args[2]
} else {
  stop("Must supply two arguments.")
}

load(data_set)

# This creates the matching and stores it in `matches`
source(paste0("match_funcs/", match_fun, ".R"))

source("stats.R")

cat(match_fun, sample_size, sim_run, get_stats(raw_data, matches), "\n")
