suppressPackageStartupMessages(library("Matching"))

matches_raw <- Match(Tr = (raw_data$treated == "T"),
                     X = as.matrix(raw_data[, c("x1", "x2")]),
                     M = 1,
                     replace = FALSE,
                     ties = FALSE)

stopifnot(all(!duplicated(matches_raw$index.treated)),
          all(!duplicated(matches_raw$index.control)))

matches <- rep(NA, sample_size_int)
matches[matches_raw$index.treated] <- 1L:length(matches_raw$index.treated)
matches[matches_raw$index.control] <- matches[matches_raw$index.treated]
