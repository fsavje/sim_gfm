source("../misc.R")

normal_node_dir <- paste0(get_scratch_dir(), "normal_node")
bigmem_node_dir <- paste0(get_scratch_dir(), "bigmem_node")

if (!file.exists(normal_node_dir)) {
  warning("Invalid to_run dir.")
  quit("no", 1)
} else if (!file.exists(bigmem_node_dir)) {
  warning("Invalid to_run dir.")
  quit("no", 1)
}

n_rounds <- as.integer(get_config("NROUNDS", "env.sh"))

set.seed(06041986)

level1_sample_sizes <- c("2e1", "1e2", "1e3", "25e2", "50e2",
                         "75e2", "1e4", "125e2", "150e2")

level2_sample_sizes <- c("175e2", "2e4", "225e2", "250e2", "275e2", "300e2")

level3_sample_sizes <- c("325e2", "350e2", "375e2", "400e2")

level4_sample_sizes <- c("425e2", "450e2", "475e2", "5e4", "1e5", "1e6")

level5_sample_sizes <- c("1e7", "2e7", "3e7", "4e7", "5e7", "6e7", "7e7",
                         "8e7", "9e7", "1e8")

invisible(lapply(level1_sample_sizes, write_batches, "level1", normal_node_dir))
invisible(lapply(level2_sample_sizes, write_batches, "level2", bigmem_node_dir))
invisible(lapply(level3_sample_sizes, write_batches, "level3", bigmem_node_dir))
invisible(lapply(level4_sample_sizes, write_batches, "level4", bigmem_node_dir))
invisible(lapply(level5_sample_sizes, write_batches, "level5", bigmem_node_dir))
