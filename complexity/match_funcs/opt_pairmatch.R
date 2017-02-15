suppressPackageStartupMessages(library("optmatch"))
options("optmatch_max_problem_size" = Inf)

optmatch_dist_mat <- match_on(treated ~ x1 + x2,
                              data = raw_data,
                              method = "euclidean")
matches <- pairmatch(optmatch_dist_mat,
                     controls = 1,
                     data = raw_data)
