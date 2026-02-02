# Function to check and load package if necessary, silently
load_package <- function(package_name) {
  if (!requireNamespace(package_name, quietly = TRUE)) {
    # Package not installed, install it silently
    install.packages(package_name, quiet = TRUE)
  }
  # Load the package silently without startup messages
  suppressPackageStartupMessages(library(package_name, character.only = TRUE))
}

# Example: Load devtools, fs, and later silently if needed
load_package("devtools")
load_package("fs")
load_package("later")
tryCatch(
  {
    devtools::install(build = TRUE, reload = TRUE, update = )
  },
  error = function(e) {
    # If an error occurs (i.e., renv blocks the install), install the package using devtools
    message(e$message)
  }
)

# Define the path to the package or repo directory
package_path <- "."  # Replace with your actual package path
test_dir_path <- file.path(package_path, "R")  # Path to the tests directory

# Store the last modified time of files in the test directory
last_modified_time <- Sys.time()

# Function to run tests using devtools::test()
run_tests <- function() {
  cat("Running tests...\n")
  devtools::test()  # Run all tests for the package using devtools::test()
  cat("Tests completed.\n")
}

# Function to check for changes in the test directory
check_for_changes <- function() {
  # Get a list of files in the test directory
  files <- fs::dir_info(test_dir_path)
  
  # Check if any file has been modified since the last check
  new_modified_time <- max(files$modification_time)
  
  if (new_modified_time > last_modified_time) {
    cat("File change detected! Re-running tests...\n")
    run_tests()  # Trigger the test run
    last_modified_time <<- new_modified_time  # Update the last modified time
  }
  
  # Re-run the check every 1 second
  later::later(check_for_changes, 1)
}

# Start checking for changes in the tests directory
check_for_changes()

# Keep the R session running to allow monitoring
cat("Watching for changes in the tests directory...\n")

# Block the script to keep the R session active
while(TRUE) {
  later::run_now()  # Keep running scheduled tasks
  Sys.sleep(1)  # Sleep for 1 second before checking again
}
