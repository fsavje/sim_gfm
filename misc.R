get_config <- function(config_name, file_name) {
  file_handle <- file(file_name, "r")
  file_lines <- readLines(file_handle)
  close(file_handle)
  file_lines <- file_lines[grep(paste0("^", config_name, "="), file_lines)[1]]
  unlist(strsplit(file_lines, "=", fixed = TRUE))[2]
}

get_scratch_dir <- function() {
  gl_scratch_dir <- get_config("GL_SCRATCH_DIR", "../global_env.sh")
  scratch_subdir <- get_config("SCRATCH_SUBDIR", "env.sh")
  scratch_dir <- paste0(gl_scratch_dir, scratch_subdir)
  if (!file.exists(substr(scratch_dir, 1, nchar(scratch_dir) - 1))) {
    warning("Invalid scratch dir.")
    quit("no", 1)
  }
  scratch_dir
}

make_seed <- function() {
  as.integer(floor(runif(1) * 100000000))
}

write_batches <- function(sample_size, to_run, folder) {
  invisible(lapply(1L:n_rounds, function(r) {
    write_to_file <- file(paste0(folder, "/", sample_size, "-", r), "w")
    cat(paste0("BATCHSET=\"", sample_size, " ", r, " ", make_seed(), "\""),
        paste0("TORUN=\"", to_run, "\""),
        file = write_to_file, sep = "\n")
    close(write_to_file)
  }))
}
