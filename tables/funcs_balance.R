make_sub_table <- function(compiled_results,
                           methods_include,
                           stats_cols,
                           ss,
                           title,
                           cols_to_normalize = NULL,
                           normalize_with = NULL,
                           digits = 2,
                           nsmall = 2) {
  tmp_results <- compiled_results[compiled_results$sample_size == ss &
                                    compiled_results$method %in% methods_include,
                                  c("method", stats_cols)]
  tmp_results <- tmp_results[match(methods_include, tmp_results$method), ]

  tmp_results[, cols_to_normalize] <- t(t(as.matrix(tmp_results[, cols_to_normalize, drop = FALSE])) /
                                          as.numeric(normalize_with[, cols_to_normalize, drop = FALSE]))

  tmp_mat <- sapply(tmp_results[, stats_cols],
                    function(col) {
                      format(col, justify = "right", digits = digits, nsmall = nsmall, scientific = FALSE)
                    })
  tmp_mat <- apply(tmp_mat, 1, paste, collapse = " & ")
  tmp_mat <- paste("& &", tmp_mat)
  tmp_mat <- sub("\\\\", " \\\\", tmp_mat)
  matrix(tmp_mat, ncol = 1)
}


save_table <- function(file,
                       res_mat,
                       row_labels) {
  res_mat <- cbind(format(row_labels, justify = "left"),
                   res_mat)
  res_mat <- apply(res_mat, 1, paste, collapse = " ")
  res_mat <- paste(res_mat, " \\\\")
  cat(paste(res_mat, collapse = "\n"), "\n", file = file, sep = "")
}
