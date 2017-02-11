result_file <- commandArgs(trailingOnly = TRUE)[1]

if (!file.exists(result_file)) {
  stop("Cannot find result file.")
}

sim_col_names <- c("method",
                   "sample_size",
                   "sim_run",
                   "avg_mean_dist",
                   "avg_max_dist",
                   "avg_mean_tc_dist",
                   "avg_max_tc_dist",
                   "trw_mean_dist",
                   "trw_max_dist",
                   "trw_mean_tc_dist",
                   "trw_max_tc_dist",
                   "gsw_mean_dist",
                   "gsw_max_dist",
                   "gsw_mean_tc_dist",
                   "gsw_max_tc_dist",
                   "ave_group_size",
                   "var_group_size",
                   "share_discarded",
                   "var_weights",
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
