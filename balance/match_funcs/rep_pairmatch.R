suppressPackageStartupMessages(library("Matching"))

matches_raw <- Match(Tr = (raw_data$treated == "T"),
                     X = as.matrix(raw_data[, c("x1", "x2")]),
                     M = 1,
                     replace = TRUE,
                     ties = FALSE,
                     version = "fast")

stopifnot(all(!duplicated(matches_raw$index.treated)))

matches <- rep(NA, sample_size_int)
matches[unique(matches_raw$index.control)] <- 1L:length(unique(matches_raw$index.control))
matches[matches_raw$index.treated] <- matches[matches_raw$index.control]
