suppressPackageStartupMessages(library("Rscclust"))

load(commandArgs(trailingOnly = TRUE)[1])

match_dist <- make_distances(as.matrix(raw_data[, c("x1", "x2")]))
matches <- make_clustering(match_dist,
                           type_labels = raw_data$treated,
                           type_constraints = c("T" = 1, "C" = 1),
                           seed_method = "exclusion_updating",
                           primary_unassigned_method = "closest_seed")

cat("scclust_EXU_CSE", sample_size, sim_run, " ")
