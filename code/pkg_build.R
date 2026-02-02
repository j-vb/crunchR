# Ensure devtools is installed
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# Function to build the package
build_package_binary <- function(output_path = NULL) {
  # Get the current working directory (assumes this is the repo root)
  repo_path <- normalizePath(getwd())

  # Set default output path to the parent directory of the repo
  if (is.null(output_path)) {
    output_path <- normalizePath(file.path(repo_path, ".."))
  }

  # Ensure the output path exists
  if (!dir.exists(output_path)) {
    dir.create(output_path, recursive = TRUE)
  }

  # Detect the operating system
  os <- .Platform$OS.type
  binary_ext <- if (os == "windows") ".zip" else ".tar.gz"

  # Build the package
  cat("Building the package...\n")
  devtools::build(path = output_path, binary = TRUE)

  # Verify the binary file exists
  binary_files <- list.files(output_path, pattern = paste0(binary_ext, "$"), full.names = TRUE)
  if (length(binary_files) > 0) {
    cat("Package built successfully:\n")
    print(binary_files)
  } else {
    stop("Failed to build the package binary.")
  }
}

# Run the function
build_package_binary()
