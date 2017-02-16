suppressPackageStartupMessages(library("Matching"))

matches <- Match(Tr = (raw_data$treated == "T"),
                 X = as.matrix(raw_data[, c("x1", "x2")]),
                 M = 2,
                 replace = FALSE,
                 ties = FALSE,
                 version = "fast")
