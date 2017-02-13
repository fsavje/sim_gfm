result_file <- commandArgs(trailingOnly = TRUE)[1]

if (!file.exists(result_file)) {
  stop("Cannot find result file.")
}

sim_col_names <- c("method",
                   "sample_size",
                   "sim_run",
                   "sys_time",
                   "app_time",
                   "memory")

collected_results <- read.table(result_file,
                                col.names = sim_col_names,
                                stringsAsFactors = FALSE)

save(collected_results,
     file = "../collected/complexity.Rdata",
     compress = "bzip2")
