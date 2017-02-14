source("../misc.R")

outfile <- "./compiled/complexity.Rdata"

if (file.exists(outfile)) {
  warning("Compiled data already generated.")
  quit("no", 1)
}

load("../collected/complexity.Rdata")

expected_n_rounds <- as.integer(get_config("NROUNDS", "../complexity/env.sh"))

round_count <- aggregate(list(count = collected_results$sim_run),
                         list(method = collected_results$method,
                              sample_size = collected_results$sample_size),
                         length)

stopifnot(all(round_count$count == expected_n_rounds))

collected_results$tot_time <- collected_results$sys_time + collected_results$app_time

compiled_results <- aggregate(collected_results[, c("tot_time",
                                                    "memory")],
                              list(method = collected_results$method,
                                   sample_size = collected_results$sample_size),
                              mean)

save(compiled_results, file = outfile)
