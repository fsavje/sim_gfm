source("../misc.R")

normal_node_dir <- paste0(get_scratch_dir(), "normal_node")
bigmem_node_dir <- paste0(get_scratch_dir(), "bigmem_node")

if (!file.exists(normal_node_dir)) {
  warning("Invalid `normal_node_dir` dir.")
  quit("no", 1)
} else if (!file.exists(bigmem_node_dir)) {
  warning("Invalid `bigmem_node_dir` dir.")
  quit("no", 1)
}

n_rounds <- as.integer(get_config("NROUNDS", "env.sh"))

set.seed(06041986)

# opt_kmatch
level1_sample_sizes <- c("2e1", "1e2", "5e2", "1e3", "5e3", "10e3")

# opt_pairmatch
level2_sample_sizes <- c("15e3", "20e3")

# opt_fullmatch
level3_sample_sizes <- c("25e3", "30e3", "35e3", "40e3")

# gre_kmatch gre_pairmatch rep_pairmatch
level4_sample_sizes <- c("45e3", "50e3", "55e3", "10e4", "15e4", "20e4", "25e4", "30e4")

# scclust_EXU_CSE scclust_LEX_ANY
level5_sample_sizes_nor <- c("35e4", "40e4", "45e4", "50e4", "55e4", "10e5", "50e5", "1e7", "2e7")
level5_sample_sizes_big <- c("3e7", "4e7", "5e7", "6e7", "7e7", "8e7", "9e7", "10e7")

invisible(lapply(level1_sample_sizes, write_batches, "level1", normal_node_dir))
invisible(lapply(level2_sample_sizes, write_batches, "level2", bigmem_node_dir))
invisible(lapply(level3_sample_sizes, write_batches, "level3", bigmem_node_dir))
invisible(lapply(level4_sample_sizes, write_batches, "level4", normal_node_dir))
invisible(lapply(level5_sample_sizes_nor, write_batches, "level5", normal_node_dir))
invisible(lapply(level5_sample_sizes_big, write_batches, "level5", bigmem_node_dir))
