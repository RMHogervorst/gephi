#' Write to csv
#'
#' This function will use the readr version of write_csv
#' if it can be found, and will fall back to write.csv
#' from base if not. This allows me to keep the number
#' of dependencies low.
#' @importFrom utils write.csv
#' @noRd
write_safe <- function(x, path, na = "") {
  if (requireNamespace("readr", quietly = TRUE)) {
    readr::write_csv(x = x, path = path, na = na)
  } else {
    write.csv(x = x, file = path, na.strings = na)
  }
}

read_safe <- function(path, na = "") {
  if (requireNamespace("readr", quietly = TRUE)) {
    readr::read_csv(file = path, na = na)
  } else {
    read.csv(file = path, na = na)
  }
}
