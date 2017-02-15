source("../misc.R")

result_file <- commandArgs(trailingOnly = TRUE)[1]

if (!file.exists(result_file)) {
  warning("Cannot find result file.")
  quit("no", 1)
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

expected_num_rounds <- as.integer(get_config("NROUNDS", "env.sh"))
expected_rounds <- 1L:expected_num_rounds

check_sims <- sapply(split(collected_results, list(method = collected_results$method,
                                                   sample_size = collected_results$sample_size)),
                     function(x) {
                       (nrow(x) == 0) ||
                         ((nrow(x) == expected_num_rounds) &&
                            all(sort(x$sim_run) == expected_rounds))
                     })

if (!all(check_sims)) {
  warning("Some simulation rounds are missing.")
  quit("no", 1)
}

save(collected_results,
     file = "../collected/complexity.Rdata",
     compress = "bzip2")
