suppressPackageStartupMessages(library("Rscclust"))

match_dist <- make_distances(as.matrix(raw_data[, c("x1", "x2")]))
matches <- as.integer(make_clustering(match_dist,
                                      type_labels = raw_data$treated,
                                      type_constraints = c("T" = 1, "C" = 1),
                                      seed_method = "lexical",
                                      primary_unassigned_method = "any_neighbor"))
