# Ensure necessary packages are installed ####
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools", quiet = TRUE)
}
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", quiet = TRUE)
}
if (!requireNamespace("attachment", quietly = TRUE)) {
  install.packages("attachment", quiet = TRUE)
}

# Update the package ####
update_package <- function() {
  # Step 1: Document the package
  message("Documenting the package...")
  devtools::document()
  message("Documentation complete.")

  # Step 2: Update the DESCRIPTION file with dependencies
  message("Updating DESCRIPTION file with dependencies...")
  attachment::att_amend_desc()
  message("DESCRIPTION file updated.")

  # Step 3: Update the renv.lock file
  message("Updating renv.lock...")
  renv::clean(confirm = FALSE)
  renv::snapshot(prompt = FALSE)
  message("renv.lock updated.")
}

# Run the update process with error handling ####
tryCatch(
  {
    update_package()
  },
  error = function(e) {
    message("An error occurred: ", e$message)
  }
)
