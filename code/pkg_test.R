# Load devtools and testthat
library(devtools)
library(testthat)

# Run testthat tests and capture output
test_output <- capture.output({
  devtools::test()
})

# Prefix output with date and time
current_time <- format(Sys.time(), "%d %B %Y - %H:%M:%S")
test_output <- c(paste("Date: ", current_time, "\n\n"), test_output)

# Write the output to a .txt file
writeLines(test_output, "./code/test-output.txt")

# Print a message to confirm the file was written
cat("Test output written to './code/test-output.txt'\n")
