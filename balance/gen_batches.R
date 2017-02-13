source("../misc.R")

to_run_dir <- paste0(get_scratch_dir(), "to_run")
n_rounds <- as.integer(get_config("NROUNDS", "env.sh"))

if (!file.exists(to_run_dir)) {
  warning("Invalid to_run dir.")
  quit("no", 1)
}

set.seed(06041986)

invisible(lapply(c("1e2", "1e3"), write_batches, "all", to_run_dir))
invisible(lapply(c("1e4"), write_batches, "high", to_run_dir))
