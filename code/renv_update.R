# Ensure renv is installed
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

# Update all packages
renv::update()

# Resnapshot the environment
renv::snapshot()

cat("All packages updated and renv.lock has been updated.\n")
