library("ggplot2")

source("funcs_complexity.R")

pdf(NULL)

load("./compiled/complexity.Rdata")

# Time in minutes
compiled_results$tot_time <- compiled_results$tot_time / 60
# Memory in GB
compiled_results$memory <- compiled_results$memory / 1024^2

small_ss <- c(2e1, 5e3, 10e3, 15e3, 20e3, 25e3, 30e3, 35e3, 40e3, 45e3, 50e3)
medium_ss <- c(2e1, 50e3, 10e4, 15e4, 20e4, 25e4, 30e4, 35e4, 40e4, 45e4, 50e4)
big_ss <- c(2e1, 1e7, 2e7, 3e7, 4e7, 5e7, 6e7, 7e7, 8e7, 9e7, 10e7)



small_cpu_data <- compiled_results[compiled_results$sample_size %in% small_ss &
                                     compiled_results$method %in% c("gre_pairmatch",
                                                                    "opt_pairmatch",
                                                                    "rep_pairmatch",
                                                                    "gre_kmatch",
                                                                    "opt_kmatch",
                                                                    "opt_fullmatch",
                                                                    "scclust_LEX_ANY",
                                                                    "scclust_EXU_CSE"),
                                   c("method", "sample_size", "tot_time")]

small_cpu_data <- rbind(small_cpu_data,
                        extrapolate_cpu("opt_pairmatch", 28e3),
                        extrapolate_cpu("opt_kmatch", 12e3),
                        extrapolate_cpu("opt_kmatch", 13e3),
                        extrapolate_cpu("opt_kmatch", 14e3),
                        extrapolate_cpu("opt_fullmatch", 55e3))



small_mem_data <- compiled_results[compiled_results$sample_size %in% small_ss &
                                     compiled_results$method %in% c("rep_pairmatch",
                                                                    "opt_fullmatch",
                                                                    "scclust_EXU_CSE"),
                                   c("method", "sample_size", "memory")]

small_mem_data <- rbind(small_mem_data,
                        extrapolate_memory("opt_fullmatch", 50e3))



medium_cpu_data <- compiled_results[compiled_results$sample_size %in% medium_ss &
                                      compiled_results$method %in% c("gre_pairmatch",
                                                                     "rep_pairmatch",
                                                                     "gre_kmatch",
                                                                     "scclust_LEX_ANY",
                                                                     "scclust_EXU_CSE"),
                                    c("method", "sample_size", "tot_time")]

medium_cpu_data <- rbind(medium_cpu_data,
                         extrapolate_cpu("gre_pairmatch", 40e4),
                         extrapolate_cpu("rep_pairmatch", 40e4),
                         extrapolate_cpu("gre_kmatch", 40e4))



medium_mem_data <- compiled_results[compiled_results$sample_size %in% medium_ss &
                                      compiled_results$method %in% c("rep_pairmatch",
                                                                     "scclust_EXU_CSE"),
                                    c("method", "sample_size", "memory")]

medium_mem_data <- rbind(medium_mem_data,
                         extrapolate_memory("rep_pairmatch", 55e4))



big_cpu_data <- compiled_results[compiled_results$sample_size %in% big_ss &
                                   compiled_results$method %in% c("scclust_LEX_ANY",
                                                                  "scclust_EXU_CSE"),
                                 c("method", "sample_size", "tot_time")]

big_mem_data <- compiled_results[compiled_results$sample_size %in% big_ss &
                                   compiled_results$method %in% c("scclust_EXU_CSE"),
                                 c("method", "sample_size", "memory")]



palette <- c(opt_pairmatch = "#377eb8",
             opt_kmatch = "#377eb8",
             opt_fullmatch = "#377eb8",
             gre_pairmatch = "#e41a1c",
             gre_kmatch = "#e41a1c",
             rep_pairmatch = "#e41a1c",
             scclust_LEX_ANY = "#4daf4a",
             scclust_EXU_CSE = "#4daf4a")

shapes <- c(opt_pairmatch = 21,
            opt_kmatch = 22,
            opt_fullmatch = 24,
            gre_pairmatch = 24,
            gre_kmatch = 22,
            rep_pairmatch = 21,
            scclust_LEX_ANY = 24,
            scclust_EXU_CSE = 22)

linetype <- c(opt_pairmatch = "dotted",
              opt_kmatch = "dotted",
              opt_fullmatch = "dotted",
              gre_pairmatch = "dashed",
              gre_kmatch = "dashed",
              rep_pairmatch = "dashed",
              scclust_LEX_ANY = "solid",
              scclust_EXU_CSE = "solid")

legend_title <- "Matching methods"

legend_order <- c("opt_pairmatch",
                  "opt_kmatch",
                  "opt_fullmatch",
                  "gre_pairmatch",
                  "gre_kmatch",
                  "rep_pairmatch",
                  "scclust_LEX_ANY",
                  "scclust_EXU_CSE")

legend_labels <- c(gre_pairmatch = "Greedy NN",
                   opt_pairmatch = "Optimal NN",
                   rep_pairmatch = "NN with replacement     ",
                   gre_kmatch = "Greedy 1:2",
                   opt_kmatch = "Optimal 1:2",
                   opt_fullmatch = "Full matching     ",
                   scclust_LEX_ANY = "GFM",
                   scclust_EXU_CSE = "GFM refined")


small_cpu_plot <- ggplot(small_cpu_data, aes(y = tot_time))
small_cpu_plot <- plot_base(small_cpu_plot, "small", "cpu", "A", 0.9)
save_plot(small_cpu_plot, "small_cpu.pdf")

medium_cpu_plot <- ggplot(medium_cpu_data, aes(y = tot_time))
medium_cpu_plot <- plot_base(medium_cpu_plot, "medium", "cpu", "B", 0.8)
save_plot(medium_cpu_plot, "medium_cpu.pdf")

big_cpu_plot <- ggplot(big_cpu_data, aes(y = tot_time))
big_cpu_plot <- plot_base(big_cpu_plot, "big", "cpu", "C", 0.8)
save_plot(big_cpu_plot, "big_cpu.pdf")

small_mem_plot <- ggplot(small_mem_data, aes(y = memory))
small_mem_plot <- plot_base(small_mem_plot, "small", "mem", "D", 0.8)
save_plot(small_mem_plot, "small_mem.pdf")

medium_mem_plot <- ggplot(medium_mem_data, aes(y = memory))
medium_mem_plot <- plot_base(medium_mem_plot, "medium", "mem", "E", 0.8)
save_plot(medium_mem_plot, "medium_mem.pdf")

big_mem_plot <- ggplot(big_mem_data, aes(y = memory))
big_mem_plot <- plot_base(big_mem_plot, "big", "mem", "F", 0.8)
save_plot(big_mem_plot, "big_mem.pdf")


legend_guide <- guide_legend(nrow = 3, byrow = FALSE, keywidth = 2.8)
legend_grob <- small_cpu_plot +
  guides(colour = legend_guide,
         fill = legend_guide,
         shape = legend_guide,
         linetype = legend_guide) +
  theme(legend.background = element_rect(size = 0.5, colour = "#CCCCCC"),
        legend.position = c(0.02, 0.05),
        legend.justification = c(0.01, 0.01))
legend_grob <- ggplotGrob(legend_grob)$grobs
legend_grob <- legend_grob[[which(sapply(legend_grob, function(x) x$name) == "guide-box")]]
#grid.draw(legend_grob)
ggsave("output/legend.pdf", legend_grob, scale = 2,
       width = 6.3, height = 1.45, units = "cm")
