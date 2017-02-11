suppressPackageStartupMessages(library("optmatch"))
options("optmatch_max_problem_size" = Inf)

optmatch_dist_mat <- match_on(treated ~ x1 + x2,
                              data = raw_data,
                              method = "euclidean")
matches <- as.integer(pairmatch(optmatch_dist_mat,
                                controls = 2,
                                data = raw_data))
