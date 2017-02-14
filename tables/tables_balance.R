source("funcs.R")

load("./compiled/balance.Rdata")

# tmp
compiled_results <- rbind(compiled_results,
                          compiled_results[1, ],
                          compiled_results[1, ],
                          compiled_results[24, ],
                          compiled_results[24, ],
                          compiled_results[47, ],
                          compiled_results[47, ])
compiled_results$method[70] <- "opt_pairmatch"
compiled_results$method[71] <- "opt_kmatch"
compiled_results$method[72] <- "opt_pairmatch"
compiled_results$method[73] <- "opt_kmatch"
compiled_results$method[74] <- "opt_pairmatch"
compiled_results$method[75] <- "opt_kmatch"


# Make additional statistics

compiled_results$bias_se_ratio <- compiled_results$bias / compiled_results$std_err
compiled_results$rmse_rel <- compiled_results$rmse
compiled_results$rmse_abs <- compiled_results$rmse


# Settings common for all tables

methods_include <- c("Unadjusted" = "no_match",
                     "Greedy NN" = "gre_pairmatch",
                     "Optimal NN" = "opt_pairmatch",
                     "With replacement" = "rep_pairmatch",
                     "Greedy 1:2" = "gre_kmatch",
                     "Optimal 1:2" = "opt_kmatch",
                     "Full matching" = "opt_fullmatch",
                     "GFM" = "scclust_LEX_ANY",
                     "GFM refined" = "scclust_EXU_CSE")

normalize_with <- "opt_fullmatch"

sample_sizes <- c(1e3L, 1e4L)


# Table 1: distances

distance_cols <- c("gsw_mean_dist",
                   "gsw_mean_tc_dist",
                   "trw_mean_dist",
                   "trw_mean_tc_dist",
                   "max_dist",
                   "max_tc_dist")

make_table("./output/table_distances.tex",
           compiled_results,
           methods_include,
           distance_cols,
           sample_sizes,
           distance_cols,
           normalize_with,
           col_labels = distance_cols)


# Table 2: misc

misc_cols <- c("ave_group_size",
               "var_group_size",
               "share_discarded",
               "var_weights_control")

make_table("./output/table_misc.tex",
           compiled_results,
           methods_include,
           misc_cols,
           sample_sizes,
           c("var_weights_control"),
           normalize_with,
           col_labels = misc_cols)


# Table 3: balance

balance_cols <- c("abs_bal_x1",
                  "abs_bal_x2",
                  "abs_bal_x1_sq",
                  "abs_bal_x2_sq",
                  "abs_bal_x1x2")

make_table("./output/table_balance.tex",
           compiled_results,
           methods_include,
           balance_cols,
           sample_sizes,
           balance_cols,
           normalize_with,
           col_labels = balance_cols)


# Table 4: RMSE etc

rmse_cols <- c("bias",
               "std_err",
               "bias_se_ratio",
               "rmse_rel",
               "rmse_abs")

rmse_normalize <- c("bias",
                    "std_err",
                    "rmse_rel")

make_table("./output/table_rmse.tex",
           compiled_results,
           methods_include,
           rmse_cols,
           sample_sizes,
           rmse_normalize,
           normalize_with,
           col_labels = rmse_cols)
