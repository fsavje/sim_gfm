source("funcs_balance.R")

load("./compiled/balance.Rdata")

# Make additional statistics

compiled_results$bias_se_ratio <- compiled_results$bias / compiled_results$std_err

# Settings common for all tables

all_methods <- c("Unadjusted" = "no_match",
                 "Greedy NN" = "gre_pairmatch",
                 "Optimal NN" = "opt_pairmatch",
                 "With replacement" = "rep_pairmatch",
                 "Greedy 1:2" = "gre_kmatch",
                 "Optimal 1:2" = "opt_kmatch",
                 "Full matching" = "opt_fullmatch",
                 "GFM" = "scclust_LEX_ANY",
                 "GFM refined" = "scclust_EXU_CSE")

matching_methods <- all_methods[all_methods != "no_match"]

normalize_with <- compiled_results[compiled_results$method == "opt_fullmatch" &
                                     compiled_results$sample_size == 1e3L, ]

sample_sizes <- c(1e3L, 1e4L)


# Table 1: distances

distance_cols <- c("max_dist",
                   "max_tc_dist",
                   "mean_dist",
                   "mean_tc_dist",
                   "sum_dist")

make_table("./output/table_distances.tex",
           compiled_results,
           matching_methods,
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
           all_methods,
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
           all_methods,
           balance_cols,
           sample_sizes,
           balance_cols,
           normalize_with,
           col_labels = balance_cols)


# Table 4: RMSE etc

rmse_cols <- c("bias",
               "std_err",
               "rmse",
               "bias_se_ratio")

rmse_normalize <- c("bias",
                    "std_err",
                    "rmse")

make_table("./output/table_rmse.tex",
           compiled_results,
           all_methods,
           rmse_cols,
           sample_sizes,
           rmse_normalize,
           normalize_with,
           col_labels = rmse_cols)
