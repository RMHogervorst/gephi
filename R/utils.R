#' Write to csv
#'
#' This function will use the readr version of write_csv
#' if it can be found, and will fall back to write.csv
#' from base if not. This allows me to keep the number
#' of dependencies low.
#' @importFrom utils write.csv
#' @noRd
write_safe <- function(x, path, na = "", sep = ",") {
  if (requireNamespace("readr", quietly = TRUE)) {
    if (sep == ",") {
      readr::write_csv(x = x, path = path, na = na)
    } else if (sep == ";") {
      readr::write_csv2(x = x, path = path, na = na)
    } else {
      stop("Seperator (sep) needs to be , or ;")
    }
  } else {
    utils::write.table(x = x, file = path,na = na, sep = sep)
  }
}

read_safe <- function(path, na = "", sep = ",") {
  if (requireNamespace("readr", quietly = TRUE)) {
    if (sep == ",") {
      readr::read_csv(file = path, na = na)
    } else if (sep == ";") {
      readr::read_csv2(file = path, na = na)
    } else {
      stop("Seperator (sep) needs to be , or ;")
    }
  } else {
    utils::read.table(file = path, na = na, sep = sep)
  }
}
