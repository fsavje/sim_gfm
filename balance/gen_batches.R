source("misc.R")

to_run_dir <- paste0(get_scratch_dir(), "to_run")
n_rounds <- as.integer(get_config("NROUNDS", "env.sh"))

if (!file.exists(to_run_dir)) {
  warning("Invalid to_run dir.")
  quit("no", 1)
}

make_seed <- function() {
  as.integer(floor(runif(1) * 100000000))
}

write_batches <- function(sample_size, to_run, folder) {
  invisible(lapply(1L:n_rounds, function(r) {
    write_to_file <- file(paste0(folder, "/", sample_size, "-", r), "w")
    cat(paste0("BATCHSET=\"", sample_size, " ", r, " ", make_seed(), "\""),
        paste0("TORUN=\"", to_run, "\""),
        file = write_to_file, sep = "\n")
    close(write_to_file)
  }))
}

set.seed(06041986)

invisible(lapply(c("1e2", "1e3"), write_batches, "all", to_run_dir))
invisible(lapply(c("1e4"), write_batches, "high", to_run_dir))
