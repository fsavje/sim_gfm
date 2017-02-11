# Not estimating var, i.e., don't want biased corrected
real_var <- function(x) {
  mean((x - mean(x))^2)
}

estimator <- function(outcome,
                      treated,
                      weights) {
  sum(weights[treated] * outcome[treated]) - sum(weights[!treated] * outcome[!treated])
}

get_stats <- function(raw_data,
                      matches) {
  stopifnot(is.integer(matches),
            length(matches) == sample_size_int,
            !any(is.na(matches[raw_data$treated == "T"])),
            Rscclust::check_clustering(Rscclust::Rscc_clustering(matches),
                                       type_labels = raw_data$treated,
                                       type_constraints = c("T" = 1, "C" = 1)))

  treated <- (raw_data$treated == "T")

  # Calculate matching weights
  tmp_matches <- matches
  tmp_matches[is.na(tmp_matches)] <- max(tmp_matches, na.rm = TRUE) + 1L
  num_same_treatment_in_group <- ave(tmp_matches,
                                     raw_data$treated,
                                     tmp_matches,
                                     FUN = length)
  num_treated_in_group <- ave(treated,
                              tmp_matches,
                              FUN = sum)
  num_treated_in_total <- sum(treated)
  weights <- num_treated_in_group / (num_treated_in_total * num_same_treatment_in_group)
  weights[is.na(matches)] <- 0.0

  # Get matched group info
  gi <- do.call(rbind, lapply(split(raw_data, matches),
                              function(in_df) {
                                g_dist <- dist(as.matrix(in_df[, c("x1", "x2")]))
                                tc_dist <- as.matrix(g_dist)[in_df$treated == "T", in_df$treated == "C", drop = FALSE]
                                data.frame(mean_dist = mean(g_dist),
                                           max_dist = max(g_dist),
                                           mean_tc_dist = mean(tc_dist),
                                           max_tc_dist = max(tc_dist),
                                           group_size = nrow(in_df),
                                           num_treated = sum(in_df$treated == "T"),
                                           group_te = mean(in_df$y[in_df$treated == "T"]) - mean(in_df$y[in_df$treated == "C"]))
                              }))

  te_estimate1 <- estimator(raw_data$y, treated, weights)
  te_estimate2 <- sum(gi$num_treated * gi$group_te) / sum(gi$num_treated)

  # Sanity check
  stopifnot(all.equal(te_estimate1, te_estimate2))

  c(avg_mean_dist = mean(gi$mean_dist),
    avg_max_dist = mean(gi$max_dist),
    avg_mean_tc_dist = mean(gi$mean_tc_dist),
    avg_max_tc_dist = mean(gi$max_tc_dist),
    trw_mean_dist = sum(gi$num_treated * gi$mean_dist) / sum(gi$num_treated),
    trw_max_dist = sum(gi$num_treated * gi$max_dist) / sum(gi$num_treated),
    trw_mean_tc_dist = sum(gi$num_treated * gi$mean_tc_dist) / sum(gi$num_treated),
    trw_max_tc_dist = sum(gi$num_treated * gi$max_tc_dist) / sum(gi$num_treated),
    gsw_mean_dist = sum(gi$group_size * gi$mean_dist) / sum(gi$group_size),
    gsw_max_dist = sum(gi$group_size * gi$max_dist) / sum(gi$group_size),
    gsw_mean_tc_dist = sum(gi$group_size * gi$mean_tc_dist) / sum(gi$group_size),
    gsw_max_tc_dist = sum(gi$group_size * gi$max_tc_dist) / sum(gi$group_size),
    ave_group_size = mean(gi$group_size),
    var_group_size = real_var(gi$group_size),
    share_discarded = mean(is.na(matches)),
    var_weights_treat = real_var(weights[treated]),
    var_weights_control = real_var(weights[!treated]),
    te_est = te_estimate1,
    bal_x1 = estimator(raw_data$x1, treated, weights),
    bal_x2 = estimator(raw_data$x2, treated, weights),
    bal_x1_sq = estimator(raw_data$x1^2, treated, weights),
    bal_x2_sq = estimator(raw_data$x2^2, treated, weights),
    bal_x1x2 = estimator(raw_data$x1 * raw_data$x2, treated, weights)
  )
}
