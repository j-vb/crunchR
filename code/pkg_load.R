# Load necessary libraries
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools", repos = "https://cloud.r-project.org/", quiet = TRUE)
}
if (!requireNamespace("crayon", quietly = TRUE)) {
  install.packages("crayon", repos = "https://cloud.r-project.org/", quiet = TRUE)
}

# Load the necessary packages
library(devtools)
library(crayon)

# Try to load the current package
tryCatch(
  {
    # Load the current package using load_all()
    load_all()
    message(green("Current package loaded successfully!"))
  },
  error = function(e) {
    message(red("Error loading the package: ", e$message))
    # Print the current working directory for debugging
    message(yellow("Current working directory: ", getwd()))
    # List files in the current directory for debugging
    message(blue("Files in the current directory: ", paste(list.files(), collapse = ", ")))
  }
)
