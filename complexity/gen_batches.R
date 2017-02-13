source("../misc.R")

to_run_dir <- paste0(get_scratch_dir(), "to_run")
n_rounds <- as.integer(get_config("NROUNDS", "env.sh"))

if (!file.exists(to_run_dir)) {
  warning("Invalid to_run dir.")
  quit("no", 1)
}

set.seed(06041986)

small_sample_sizes <- c("2e1", "1e2", "1e3", "25e2", "50e2", "75e2",
                        "1e4", "125e2", "150e2", "175e2", "2e4",
                        "225e2", "250e2", "275e2", "300e2")

med_sample_sizes <- c("325e2", "350e2", "375e2", "400e2")

big_sample_sizes <- c("425e2", "450e2", "475e2", "5e4", "1e5", "1e6",
                      "1e7", "2e7", "3e7", "4e7", "5e7", "6e7", "7e7",
                      "8e7", "9e7", "1e8")


invisible(lapply(small_sample_sizes, write_batches, "small", to_run_dir))
invisible(lapply(med_sample_sizes, write_batches, "med", to_run_dir))
invisible(lapply(big_sample_sizes, write_batches, "big", to_run_dir))
