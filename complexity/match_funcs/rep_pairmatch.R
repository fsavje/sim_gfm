suppressPackageStartupMessages(library("Matching"))

load(commandArgs(trailingOnly = TRUE)[1])

matches <- Match(Tr = (raw_data$treated == "T"),
                 X = as.matrix(raw_data[, c("x1", "x2")]),
                 M = 1,
                 replace = TRUE,
                 ties = FALSE)

cat("rep_pairmatch", sample_size, sim_run, " ")
