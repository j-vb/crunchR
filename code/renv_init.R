# Initialize renv for the project
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

# Initialize renv
renv::init(bare = TRUE)

# Install dependencies from DESCRIPTION
renv::install("devtools") # Ensure devtools is available
devtools::install_deps(dependencies = TRUE)

# Snapshot the environment
renv::snapshot()

cat("renv has been initialized and dependencies installed.\n")
