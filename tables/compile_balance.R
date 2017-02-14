source("../misc.R")

outfile <- "./compiled/balance.Rdata"

if (file.exists(outfile)) {
  warning("Compiled data already generated.")
  quit("no", 1)
}

load("../collected/balance.Rdata")

expected_n_rounds <- as.integer(get_config("NROUNDS", "../balance/env.sh"))

round_count <- aggregate(list(count = collected_results$avg_mean_dist),
                         list(method = collected_results$method,
                              sample_size = collected_results$sample_size),
                         length)

stopifnot(all(round_count$count == expected_n_rounds))

collected_results$abs_bal_x1 <- abs(collected_results$bal_x1)
collected_results$abs_bal_x2 <- abs(collected_results$bal_x2)
collected_results$abs_bal_x1_sq <- abs(collected_results$bal_x1_sq)
collected_results$abs_bal_x2_sq <- abs(collected_results$bal_x2_sq)
collected_results$abs_bal_x1x2 <- abs(collected_results$bal_x1x2)

collected_results$bias <- collected_results$te_est
collected_results$rmse <- collected_results$te_est^2

aggregate_means <- aggregate(collected_results[, c("avg_mean_dist",
                                                   "avg_mean_tc_dist",
                                                   "trw_mean_dist",
                                                   "trw_mean_tc_dist",
                                                   "gsw_mean_dist",
                                                   "gsw_mean_tc_dist",
                                                   "max_dist",
                                                   "max_tc_dist",
                                                   "ave_group_size",
                                                   "var_group_size",
                                                   "share_discarded",
                                                   "var_weights_treat",
                                                   "var_weights_control",
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
