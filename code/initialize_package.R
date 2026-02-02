# Package Initialization Script

# Ensure that the parent directory (the root of the project/repo) is named appropriately.
# This directory will be used to create the package. The name must contain only letters and numbers,
# and cannot contain spaces or special characters. It is recommended that the name is descriptive.

# Environment Set-up ####
library(here)
options(scipen = 999)  # Disable scientific notation for clarity

# Helper function to load packages
pkg_loader <- function(packages) {
  options(warn = -1)  # Suppress warnings temporarily
  loaded_packages <- character(0)
  error_packages <- character(0)
  
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      tryCatch(
        {
          install.packages(pkg, dependencies = TRUE, quiet = TRUE)
          library(pkg, character.only = TRUE)
          loaded_packages <- c(loaded_packages, pkg)
        },
        error = function(e) {
          error_packages <- c(error_packages, pkg)
          library(crayon)
          cat(
            "\n\033[31mError installing package(s):",
            pkg, "\033[97m\n"
          )
        }
      )
    } else {
      loaded_packages <- c(loaded_packages, pkg)
    }
  }
  
  if (length(loaded_packages) > 0) {
    cat(
      "\nFollowing package(s) were loaded:",
      paste(loaded_packages, collapse = ", "), "\n"
    )
  }
  options(warn = 0)  # Restore warnings
}

# Load required packages
pkg_loader(c("devtools", "testthat", "roxygen2", "usethis", "renv", "this.path"))

# Set working directory to the parent of the current script
setwd(dirname(dirname(this.path::this.path())))

# Initiate Project ####
## Create package environment
devtools::create(getwd())
usethis::create_package(getwd())

## Create testing environment
usethis::use_testthat()
usethis::use_test("template")

## Create documentation environment
devtools::document()

## Create reproducibility environment
renv::init()
devtools::document()

## Set-up directory structure ####
### Add data if needed ####
get_user_input <- function(prompt) {
  repeat {
    user_input <- readline(prompt = paste(prompt, ": "))  # Display prompt and capture input
    user_input <- tolower(trimws(user_input))  # Convert to lowercase and trim whitespace

    if (user_input %in% c("y", "n")) {  # Check if input is 'y' or 'n'
      return(user_input)  # Return the captured input
    } else {
      cat("Invalid input. Please enter 'y' for yes or 'n' for no.\n")
    }
  }
}
user_response <- get_user_input("Add data directories? (y/n)")


### Create necessary directories ###

if (user_response == "y") {
  dirs <- c("./R/support", "./data", "./data/data_input", "./data/data_interrim", "./data/data_output")
  sapply(dirs, dir.create, showWarnings = FALSE, recursive = TRUE)
} else (
  dirs <- c("./R/support")
  sapply(dirs, dir.create, showWarnings = FALSE, recursive = TRUE)
)

## Move existing support directory to R directory
if (dir.exists("./support")) {
  file.rename("./support", "./R/support")
}

## Append .gitignore file ####
gitignore_content <- "
# History files
.Rhistory
.Rapp.history

# Session Data files
.RData
.RDataTmp

# User-specific files
.Ruserdata

# Example code in package build process
*-Ex.R

# Output files from R CMD build
/*.tar.gz

# Output files from R CMD check
/*.Rcheck/

# RStudio files
.Rproj.user/

# produced vignettes
vignettes/*.html
vignettes/*.pdf

# R-related
.DS_Store

# Specific paths
data/data_input/*.csv
data/data_interrim/*.csv
data/data_output/*.csv
data/**/*.csv
"
cat(gitignore_content, file = ".gitignore", append = FALSE)

## Create .lintr file ####
lintr_content <- "linters: linters_with_defaults(
\tcommented_code_linter = NULL,
\tobject_usage_linter = NULL,
\tline_length_linter = NULL
\t)
"
cat(lintr_content, file = ".lintr", append = FALSE)

# Final message
cat("\nPackage initialization completed successfully!\n")
