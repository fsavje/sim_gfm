outfile <- "./compiled/complexity.Rdata"

if (file.exists(outfile)) {
  warning("Compiled data already generated.")
  quit("no", 1)
}

load("../collected/complexity.Rdata")

round_list <- lapply(split(collected_results$sim_run, list(method = collected_results$method,
                                                           sample_size = collected_results$sample_size)),
                     sort)

round_check <- sapply(round_list,
                      function(x) {
                        length(x) == length(round_list[[1]]) &&
                          all(x == round_list[[1]])
                      })

if (!all(round_check)) {
  warning("Some simulation rounds are missing.")
  quit("no", 1)
}

collected_results$tot_time <- collected_results$sys_time + collected_results$app_time

compiled_results <- aggregate(collected_results[, c("tot_time",
                                                    "memory")],
                              list(method = collected_results$method,
                                   sample_size = collected_results$sample_size),
                              mean)

save(compiled_results, file = outfile)
