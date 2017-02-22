source("funcs_balance.R")

load("./compiled/balance.Rdata")

# Make additional statistics

compiled_results$share_discarded <- 100 * compiled_results$share_discarded
compiled_results$bias_rmse_ratio <- compiled_results$bias / compiled_results$rmse
compiled_results$sd_weights_control_norm <- compiled_results$sd_weights_control * compiled_results$sample_size

# Settings common for all tables

all_methods <- c("Unadjusted" = "no_match",
                 "Greedy 1:1" = "gre_pairmatch",
                 "Optimal 1:1" = "opt_pairmatch",
                 "Replacement 1:1" = "rep_pairmatch",
                 "Greedy 1:2" = "gre_kmatch",
                 "Optimal 1:2" = "opt_kmatch",
                 "Full matching" = "opt_fullmatch",
                 "GFM" = "scclust_LEX_ANY",
                 "Refined GFM" = "scclust_EXU_CSE")

matching_methods <- all_methods[all_methods != "no_match"]

row_opt_fullmatch1e3L <- compiled_results[compiled_results$method == "opt_fullmatch" &
                                            compiled_results$sample_size == 1e3L, ]

row_opt_fullmatch1e4L <- compiled_results[compiled_results$method == "opt_fullmatch" &
                                            compiled_results$sample_size == 1e4L, ]

distance_cols <- c("$L^{Max}$" = "max_dist",
                   "$L^{Max}_{tc}$" = "max_tc_dist",
                   "$L^{Mean}$" = "mean_dist",
                   "$L^{Mean}_{tc}$" = "mean_tc_dist",
                   "$L^{Sum}_{tc}$" = "sum_dist")

misc_cols <- c("Size" = "ave_group_size",
               "$\\sigma(\\text{Size})$" = "sd_group_size",
               "\\% drop" = "share_discarded",
               "$\\sigma(\\text{wgh})$" = "sd_weights_control_norm")

balance_cols <- c("$X_1$" = "abs_bal_x1",
                  "$X_2$" = "abs_bal_x2",
                  "$X_1^2$" = "abs_bal_x1_sq",
                  "$X_2^2$" = "abs_bal_x2_sq",
                  "$X_1X_2$" = "abs_bal_x1x2")

rmse_cols <- c("Bias" = "bias",
               "\\textsc{se}" = "std_err",
               "\\textsc{rmse}" = "rmse",
               "$\\frac{\\text{Bias}}{\\text{\\textsc{rmse}}}$" = "bias_rmse_ratio")

rmse_normalize <- c("bias", "std_err", "rmse")


# Table 1: Misc and dists, 1e4L

tab_group_stats <- make_sub_table(compiled_results,
                                  matching_methods,
                                  misc_cols,
                                  1e4L,
                                  "\\underline{Panel B: Group structure}")

tab_distances <- make_sub_table(compiled_results,
                                matching_methods,
                                distance_cols,
                                1e4L,
                                "\\underline{Panel A: Distances}",
                                distance_cols,
                                row_opt_fullmatch1e4L)

save_table("output/bal_main_group_dist.tex",
           cbind(tab_distances, tab_group_stats),
           names(matching_methods),
           "\\cline{3-7} \\cline{9-12}")

tab_rmse <- make_sub_table(compiled_results,
                           all_methods,
                           rmse_cols,
                           1e4L,
                           "\\underline{Panel D: Estimator}",
                           rmse_normalize,
                           row_opt_fullmatch1e4L)

tab_balance <- make_sub_table(compiled_results,
                              all_methods,
                              balance_cols,
                              1e4L,
                              "\\underline{Panel C: Covariate balance}",
                              balance_cols,
                              row_opt_fullmatch1e4L)


save_table("output/bal_main_bal_rmse.tex",
           cbind(tab_balance, tab_rmse),
           names(all_methods),
           "\\cline{3-7} \\cline{9-12}")


# Table S1: Misc, 1e3L 1e4L

save_table("output/bal_app_group.tex",
           do.call(cbind,
                   lapply(c(1e3L, 1e4L),
                          function(x) {
                            make_sub_table(compiled_results,
                                           matching_methods,
                                           misc_cols,
                                           x,
                                           paste0("\\underline{", format(x, big.mark = ","), " units}"))
                          })),
           names(matching_methods),
           "\\cline{3-6} \\cline{8-11}")

# Table S2: dists, 1e3L 1e4L

save_table("output/bal_app_dist.tex",
           do.call(cbind,
                   lapply(c(1e3L, 1e4L),
                          function(x) {
                            make_sub_table(compiled_results,
                                           matching_methods,
                                           distance_cols,
                                           x,
                                           paste0("\\underline{", format(x, big.mark = ","), " units}"),
                                           distance_cols,
                                           row_opt_fullmatch1e3L)
                          })),
           names(matching_methods),
           "\\cline{3-7} \\cline{9-13}")

# Table S3: Balance, 1e3L 1e4L

save_table("output/bal_app_bal.tex",
           do.call(cbind,
                   lapply(c(1e3L, 1e4L),
                          function(x) {
                            make_sub_table(compiled_results,
                                           all_methods,
                                           balance_cols,
                                           x,
                                           paste0("\\underline{", format(x, big.mark = ","), " units}"),
                                           balance_cols,
                                           row_opt_fullmatch1e3L)
                          })),
           names(all_methods),
           "\\cline{3-7} \\cline{9-13}")

# Table S4: RMSE, 1e3L 1e4L

save_table("output/bal_app_rmse.tex",
           do.call(cbind,
                   lapply(c(1e3L, 1e4L),
                          function(x) {
                            make_sub_table(compiled_results,
                                           all_methods,
                                           rmse_cols,
                                           x,
                                           paste0("\\underline{", format(x, big.mark = ","), " units}"),
                                           rmse_normalize,
                                           row_opt_fullmatch1e3L)
                          })),
           names(all_methods),
           "\\cline{3-6} \\cline{8-11}")
