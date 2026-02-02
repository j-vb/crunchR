# Ensure renv is installed
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

# Check dependencies
cat("Scanning for dependencies...\n")
dependencies <- renv::dependencies()
print(dependencies)


# Use attachment to find dependencies from R scripts
cat("Finding dependencies from R scripts...\n")
script_dependencies <- attachment::att_from_rscripts()
print(script_dependencies)

# Amend the DESCRIPTION file with found dependencies
cat("Updating DESCRIPTION file with dependencies...\n")
attachment::att_amend_desc()

# Remove unused packages
renv::clean(confirm = FALSE)

# Resnapshot the environment
renv::snapshot()

cat("Unused packages removed and renv.lock has been updated.\n")
