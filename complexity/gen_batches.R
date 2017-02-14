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

# opt_kmatch
level1_sample_sizes <- c("2e1", "1e2", "5e2", "10e2", "25e2", "50e2",
                         "75e2", "100e2", "125e2")

# opt_pairmatch
level2_sample_sizes <- c("150e2", "175e2", "200e2", "225e2")

# opt_fullmatch
level3_sample_sizes <- c("250e2", "275e2", "300e2", "325e2", "350e2", "375e2", "400e2")

# gre_kmatch gre_pairmatch rep_pairmatch
level4_sample_sizes <- c("425e2", "450e2", "475e2", "500e2",
                         "6e4", "7e4", "8e4", "9e4", "10e4", "15e4",
                         "20e4", "25e4", "30e4")

# scclust_EXU_CSE scclust_LEX_ANY
level5_sample_sizes <- c("35e4", "40e4", "45e4", "50e4", "55e4", "60e4", "65e4",
                         "70e4", "75e4", "80e4", "85e4", "90e4", "95e4", "10e5",
                         "1e7", "2e7", "3e7", "4e7", "5e7", "6e7", "7e7",
                         "8e7", "9e7", "10e7")

invisible(lapply(level1_sample_sizes, write_batches, "level1", normal_node_dir))
invisible(lapply(level2_sample_sizes, write_batches, "level2", bigmem_node_dir))
invisible(lapply(level3_sample_sizes, write_batches, "level3", bigmem_node_dir))
invisible(lapply(level4_sample_sizes, write_batches, "level4", normal_node_dir))
invisible(lapply(level5_sample_sizes, write_batches, "level5", bigmem_node_dir))
