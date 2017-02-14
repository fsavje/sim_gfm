source("../misc.R")

result_file <- commandArgs(trailingOnly = TRUE)[1]

if (!file.exists(result_file)) {
  warning("Cannot find result file.")
  quit("no", 1)
}

sim_col_names <- c("method",
                   "sample_size",
                   "sim_run",
                   "mean_dist",
                   "mean_tc_dist",
                   "max_dist",
                   "max_tc_dist",
                   "sum_dist",
                   "ave_group_size",
                   "var_group_size",
                   "share_discarded",
                   "var_weights_treat",
                   "var_weights_control",
                   "te_est",
                   "bal_x1",
                   "bal_x2",
                   "bal_x1_sq",
                   "bal_x2_sq",
                   "bal_x1x2")

collected_results <- read.table(result_file,
                                col.names = sim_col_names,
                                stringsAsFactors = FALSE)

expected_num_rounds <- as.integer(get_config("NROUNDS", "env.sh"))
expected_rounds <- 1L:expected_num_rounds

check_sims <- sapply(split(collected_results, list(method = collected_results$method,
                                                   sample_size = collected_results$sample_size)),
                     function(x) {
                       nrow(x) == expected_num_rounds &&
                         all(sort(x$sim_run) == expected_rounds)
                     })

if (!all(check_sims)) {
  warning("Some simulation rounds are missing.")
  quit("no", 1)
}

save(collected_results,
     file = "../collected/balance.Rdata",
     compress = "bzip2")
