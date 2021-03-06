source("../misc.R")

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 3) {
  sample_size <- args[1]
  sim_run <- as.integer(args[2])
  seed <- as.integer(args[3])
} else {
  warning("Must supply three arguments.")
  quit("no", 1)
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

#raw_data$y <- (raw_data$x1 - 1)^2 + (raw_data$x2 - 1)^2 + rnorm(sample_size_int)
treat_prop <- 1 / (1 + exp(2.5 - 0.5 * (raw_data$x1 + 1)^2 - 0.5 *(raw_data$x2 + 1)^2))
while (TRUE) {
  tmp_treated <- rbinom(sample_size_int, 1, treat_prop)
  sum_treated <- sum(tmp_treated)
  # At least one treated and at least twice as many controls as treated
  if ((sum_treated > 0L) && (sample_size_int > 3L * sum_treated)) {
    raw_data$treated <- factor(tmp_treated, labels = c("C", "T"))
    break
  }
}

save(sim_run, sample_size, sample_size_int, raw_data, file = outfile, compress = FALSE)
cat(paste0(outfile, "\n"))
