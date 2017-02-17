make_table <- function(file,
                       table_data,
                       methods_include,
                       stat_col,
                       col_labels,
                       digits = 0,
                       nsmall = 2,
                       row_labels = names(methods_include)) {

  res_mat <- do.call(cbind,
                     lapply(split(table_data, table_data$sample_size),
                            function(df_ss) {
                              df_ss <- df_ss[df_ss$method %in% methods_include,
                                             c("method", stat_col)]
                              df_ss[match(methods_include, df_ss$method), stat_col]
                            }))

  res_mat <- apply(res_mat, 2, function(x) {
    x <- format(x, justify = "right", digits = digits, nsmall = nsmall, scientific = FALSE)
    sub("NA", "  ", x)
  })

  res_mat <- format(rbind(col_labels, res_mat), justify = "right", scientific = FALSE)
  res_mat <- apply(res_mat, 1, paste, collapse = " & ")
  res_mat <- paste("& &", res_mat)
  res_mat <- cbind(format(c(" ", row_labels), justify = "left"),
                   res_mat)
  res_mat <- apply(res_mat, 1, paste, collapse = " ")
  res_mat <- paste(paste(res_mat, collapse = " \\\\\n"), "\\\\\n")

  cat(res_mat, file = file)
}


extrapolate_cpu <- function(method, sample_size) {
  lm_res <- lm(tot_time ~ sample_size + I(sample_size^2),
               data = compiled_results[compiled_results$method == method, ])
  to_add <- data.frame(method = method,
                       sample_size = sample_size,
                       tot_time = NA)
  to_add[1, "tot_time"] <- predict(lm_res, to_add)
  to_add
}


extrapolate_memory <- function(method, sample_size) {
  lm_res <- lm(memory ~ sample_size + I(sample_size^2),
               data = compiled_results[compiled_results$method == method, ])
  to_add <- data.frame(method = method,
                       sample_size = sample_size,
                       memory = NA)
  to_add[1, "memory"] <- predict(lm_res, to_add)
  to_add
}


plot_base <- function(plot, ss, cpumem, label, smooth_span) {

  plot <- plot +
    theme_bw() +
    theme(panel.grid.major.x = element_line(size = 0.25, color = "#EEEEEE"),
          panel.grid.major.y = element_line(size = 0.25, color = "#EEEEEE"),
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          axis.title.x = element_text(vjust = 0),
          legend.key = element_blank(),
          legend.position = "none")

  if (ss == "small") {
    x_lim <- c(0, 50.5e3L)
    x_lab_pos <- 2400
    x_name <- "Data points (in thousands)"
    x_breaks <- c(0, 1e4L, 2e4L, 3e4L, 4e4L, 5e4L)
    x_labels <- c("0", "10k", "20k", "30k", "40k", "50k")
  } else if (ss == "medium") {
    x_lim <- c(0, 50.5e4L)
    x_lab_pos <- 24000
    x_name <- "Data points (in thousands)"
    x_breaks <- c(0, 1e5L, 2e5L, 3e5L, 4e5L, 5e5L)
    x_labels <- c("0", "100k", "200k", "300k", "400k", "500k")
    plot <- plot + theme(axis.title.y = element_blank())
  } else if (ss == "big") {
    x_lim <- c(0, 101e6L)
    x_lab_pos <- 62.6e5
    x_name <- "Data points (in millions)"
    x_breaks <- c(0, 2e7L, 4e7L, 6e7L, 8e7L, 1e8L)
    x_labels <- c("0", "20M", "40M", "60M", "80M", "100M")
    plot <- plot + theme(axis.title.y = element_blank())
  }

  if (cpumem == "cpu") {
    y_lim <- c(-1.25, 30)
    y_lab_pos <- 28
    y_name <- "Minutes"
    y_breaks <- c(0, 5, 10, 15, 20, 25, 30)
  } else if (cpumem == "mem") {
    y_lim <- c(-1, 40)
    y_lab_pos <- 37
    y_name <- "Gigabytes"
    y_breaks <- c(0, 10, 20, 30, 40)
  }


  plot +
    aes(x = sample_size, colour = method, shape = method, fill = method, linetype = method) +
    geom_line(stat = "smooth", method = "loess", span = smooth_span, size = 0.8, alpha = 0.4) +
    geom_point(size = 2) +
    scale_colour_manual(values = palette,
                        labels = legend_labels,
                        breaks = legend_order,
                        name = legend_title) +
    scale_fill_manual(values = palette,
                      labels = legend_labels,
                      breaks = legend_order,
                      name = legend_title) +
    scale_shape_manual(values = shapes,
                       labels = legend_labels,
                       breaks = legend_order,
                       name = legend_title) +
    scale_linetype_manual(values = linetype,
                          labels = legend_labels,
                          breaks = legend_order,
                          name = legend_title) +
    coord_cartesian(xlim = x_lim, ylim = y_lim) +
    annotate("text", x = x_lab_pos, y = y_lab_pos, label = label, size = 6) +
    scale_x_continuous(name = x_name, breaks = x_breaks, labels = x_labels) +
    scale_y_continuous(name = y_name, breaks = y_breaks)
}


save_plot <- function(plot, name) {
  ggsave(paste0("output/", name),
         plot,
         scale = 2,
         width = 6,
         height = 6,
         units = "cm")
}
