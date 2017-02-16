make_sub_table <- function(compiled_results,
                           methods_include,
                           stats_cols,
                           ss,
                           title,
                           cols_to_normalize = NULL,
                           normalize_with = NULL,
                           digits = 2,
                           nsmall = 2,
                           col_labels = names(stats_cols)) {
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
  tmp_mat <- format(rbind(col_labels, rep(" ", length(col_labels)), tmp_mat), justify = "right")
  tmp_mat <- apply(tmp_mat, 1, paste, collapse = " & ")
  tmp_mat <- format(c(paste0("\\multicolumn{", length(stats_cols), "}{c}{", title, "}"), tmp_mat), justify = "centre")
  tmp_mat <- paste("& &", tmp_mat)
  tmp_mat <- sub("\\\\", " \\\\", tmp_mat)
  matrix(tmp_mat, ncol = 1)
}


save_table <- function(file,
                       res_mat,
                       row_labels,
                       cline_add = NULL) {
  res_mat <- cbind(format(c(" ", " ", " ", row_labels), justify = "left"),
                   res_mat)
  res_mat <- apply(res_mat, 1, paste, collapse = " ")
  res_mat <- paste(res_mat, " \\\\ ")
  res_mat[2] <- paste(res_mat[2], "[0.15cm]")
  res_mat[3] <- paste(res_mat[3], "[-0.6cm]")
  if (!is.null(cline_add)) {
    res_mat[2] <- paste(res_mat[2], cline_add)
  }
  cat(paste(res_mat, collapse = "\n"), file = file)
}
