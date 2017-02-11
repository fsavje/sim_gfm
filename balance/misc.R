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
