install_dependencies <- function() {
  # Automatically define CRAN mirror
  options(repos = c(CRAN = "https://cran.r-project.org"))

  # Read DESCRIPTION file
  description <- readLines("DESCRIPTION")

  # Get package names
  ## Index of Imports as starting point
  index <- grep("Imports:", description)

  ## Index of the next important section (e.g., Depends, Suggests)
  next_index <- grep(":", description[(index + 1):length(description)])
  next_index
  if (length(next_index) > 0) {
    next_index <- next_index[1] + index
  } else {
    next_index <- NA
  }

  ## Generate package names vector
  packages <- character(0)  # Initialize an empty character vector

  if (!is.na(next_index)) {
    packages <- description[(index + 1):(next_index - 1)]
  } else (
    packages <- description[(index + 1):length(description)]
  )

  # Clean up package names
  packages <- trimws(gsub(",$", "", packages))  # Remove trailing commas
  packages <- gsub("^\\s*|\\s*$", "", packages)  # Trim whitespace from both ends
  
  # Remove empty entries and any invalid names
  packages <- packages[packages != ""]
  packages <- unlist(strsplit(packages, ","))
  packages <- trimws(packages)

  # Install packages if not already installed
  for (pkg in packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message(paste("Installing package:", pkg))
      tryCatch(
        install.packages(pkg, dependencies = TRUE),  # Install with dependencies
        error = function(e) {
          message(paste("Error installing package:", pkg))
          message("Error message: ", e$message)
        }
      )
    } else {
      message(paste("Package", pkg, "is already installed. Skipping installation."))
    }
  }
}

install_dependencies()
