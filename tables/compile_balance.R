outfile <- "./compiled/balance.Rdata"

if (file.exists(outfile)) {
  warning("Compiled data already generated.")
  quit("no", 1)
}

load("../collected/balance.Rdata")

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

collected_results$abs_bal_x1 <- abs(collected_results$bal_x1)
collected_results$abs_bal_x2 <- abs(collected_results$bal_x2)
collected_results$abs_bal_x1_sq <- abs(collected_results$bal_x1_sq)
collected_results$abs_bal_x2_sq <- abs(collected_results$bal_x2_sq)
collected_results$abs_bal_x1x2 <- abs(collected_results$bal_x1x2)

collected_results$bias <- collected_results$te_est
collected_results$rmse <- collected_results$te_est^2

collected_results$sd_group_size <- collected_results$var_group_size^0.5
collected_results$sd_weights_treat <- collected_results$var_weights_treat^0.5
collected_results$sd_weights_control <- collected_results$var_weights_control^0.5

aggregate_means <- aggregate(collected_results[, c("mean_dist",
                                                   "mean_tc_dist",
                                                   "max_dist",
                                                   "max_tc_dist",
                                                   "sum_dist",
                                                   "ave_group_size",
                                                   "sd_group_size",
                                                   "share_discarded",
                                                   "sd_weights_treat",
                                                   "sd_weights_control",
                                                   "bias",
                                                   "rmse",
                                                   "abs_bal_x1",
                                                   "abs_bal_x2",
                                                   "abs_bal_x1_sq",
                                                   "abs_bal_x2_sq",
                                                   "abs_bal_x1x2")],
                             list(method = collected_results$method,
                                  sample_size = collected_results$sample_size),
                             mean)

aggregate_means$bias <- abs(aggregate_means$bias)
aggregate_means$rmse <- aggregate_means$rmse^0.5

aggregate_se <- aggregate(list(se = collected_results$te_est),
                          list(method = collected_results$method,
                               sample_size = collected_results$sample_size),
                          sd)

stopifnot(all(aggregate_means$method == aggregate_se$method),
          all(aggregate_means$sample_size == aggregate_se$sample_size))

compiled_results <- cbind(aggregate_means, std_err = aggregate_se$se)

save(compiled_results, file = outfile)
