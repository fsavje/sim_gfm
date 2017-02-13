source("../misc.R")

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 3) {
  sample_size <- args[1]
  sim_run <- as.integer(args[2])
  seed <- as.integer(args[3])
} else {
  stop("Must supply three arguments.")
}

tmpdata_dir <- paste0(get_scratch_dir(), "tmpdata")
outfile <- paste0(tmpdata_dir, "/td-", sample_size, "-", sim_run, ".RData")

if (!file.exists(tmpdata_dir)) {
  warning("Invalid tmpdata dir.")
  quit("no", 1)
} else if (file.exists(outfile)) {
  warning("Raw data already generated.")
  quit("no", 1)
}

sample_size_int <- as.integer(sample_size)

set.seed(seed)

raw_data <- data.frame(x1 = runif(sample_size_int, min = -1, max = 1),
                       x2 = runif(sample_size_int, min = -1, max = 1))

raw_data$y <- (raw_data$x1 - 1)^2 + (raw_data$x2 - 1)^2 + rnorm(sample_size_int)
treat_prop <- 1 / (1 + exp(2.5 - 0.5 * (raw_data$x1 + 1)^2 - 0.5 *(raw_data$x2 + 1)^2))
while (TRUE) {
  raw_data$treated <- factor(rbinom(sample_size_int, 1, treat_prop), labels = c("C", "T"))
  if ((length(levels(raw_data$treated)) == 2) &&
      (3L * sum(raw_data$treated == "C") > 2L * sample_size_int)) {
    break
  }
}

save(sim_run, sample_size, sample_size_int, raw_data, file = outfile, compress = FALSE)
cat(paste0(outfile, "\n"))
