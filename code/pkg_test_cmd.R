# Load devtools
library(devtools)

# Run devtools::check() and capture output
check_output <- capture.output({
  devtools::check(quiet = TRUE)
})

# Prefix output with date and time
current_time <- format(Sys.time(), "%d, %B, %Y - %H:%M:%S")
check_output <- c(paste("Date: ", current_time, "\n\n"), check_output)

# Write the output to a .txt file
writeLines(check_output, "./code/r-cmd-output.txt")
