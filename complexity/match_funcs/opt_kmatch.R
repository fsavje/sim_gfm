suppressPackageStartupMessages(library("optmatch"))
options("optmatch_max_problem_size" = Inf)

load(commandArgs(trailingOnly = TRUE)[1])

optmatch_dist_mat <- match_on(treated ~ x1 + x2,
                              data = raw_data,
                              method = "euclidean")
matches <- pairmatch(optmatch_dist_mat,
                     controls = 2,
                     data = raw_data)

cat("opt_kmatch", sample_size, sim_run, " ")
