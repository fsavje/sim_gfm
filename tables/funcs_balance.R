make_table <- function(file,
                       compiled_results,
                       methods_include,
                       stats_cols,
                       sample_sizes,
                       cols_to_normalize,
                       normalize_with,
                       digits = 3,
                       nsmall = 2,
                       row_labels = names(methods_include),
                       col_labels = names(stats_cols)) {

  tmp_results <- do.call(rbind, lapply(split(compiled_results, compiled_results$sample_size),
                                       function (x) {
                                         x <- x[x$method %in% methods_include,
                                                c("method", "sample_size", stats_cols)]
                                         x[match(methods_include, x$method), ]
                                       }))
  tmp_results <- tmp_results[tmp_results$sample_size %in% sample_sizes, ]

  if (!is.null(cols_to_normalize)) {
    split(tmp_results[, cols_to_normalize], tmp_results$sample_size) <- lapply(split(tmp_results[, cols_to_normalize, drop = FALSE], tmp_results$sample_size),
                                                                               function (x) {
                                                                                 t(t(as.matrix(x)) / as.numeric(normalize_with[, cols_to_normalize, drop = FALSE]))
                                                                               })
  }

  res_mat <- do.call(
    cbind,
    lapply(
      split(tmp_results, tmp_results$sample_size),
      function(df_ss) {
        tmp_mat <- sapply(
          df_ss[, stats_cols],
          function(col) {
            format(col, justify = "right", digits = digits, nsmall = nsmall, scientific = FALSE)
          }
        )
        tmp_mat <- format(rbind(col_labels, tmp_mat), justify = "right")
        tmp_mat <- apply(tmp_mat, 1, paste, collapse = " & ")
        tmp_mat <- cbind(tmp_mat)
        tmp_mat <- format(c(paste0("\\multicolumn{", length(stats_cols), "}{c}{", df_ss$sample_size[1], "}"), tmp_mat), justify = "centre")
        tmp_mat <- paste("& &", tmp_mat)
      }
    )
  )

  res_mat <- cbind(format(c(" ", " ", row_labels), justify = "left"),
                   res_mat)
  res_mat <- apply(res_mat, 1, paste, collapse = " ")
  res_mat <- paste(paste(res_mat, collapse = " \\\\\n"), "\\\\\n")

  cat(res_mat, file = file)
}
