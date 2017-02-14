result_file <- commandArgs(trailingOnly = TRUE)[1]

if (!file.exists(result_file)) {
  stop("Cannot find result file.")
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

save(collected_results,
     file = "../collected/balance.Rdata",
     compress = "bzip2")
