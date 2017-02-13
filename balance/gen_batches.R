source("../misc.R")

normal_node_dir <- paste0(get_scratch_dir(), "normal_node")

if (!file.exists(normal_node_dir)) {
  warning("Invalid to_run dir.")
  quit("no", 1)
}

n_rounds <- as.integer(get_config("NROUNDS", "env.sh"))

set.seed(06041986)

invisible(lapply(c("1e2", "1e3", "1e4"), write_batches, "all", normal_node_dir))
