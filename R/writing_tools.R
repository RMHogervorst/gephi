#' Write edgefile to csv
write_edgefile <- function(x, path, Weight = NULL, Type = NULL){
    # reset column order?
    # (Target, Source, *Weight, *Type)
    # deal with possible type?
    stopifnot(is.data.frame(x))
    oldorder <- names(x)
    t <- grep("Target", oldorder)
    s <- grep("Source", oldorder)
    others <- seq_len(NCOL(x))[c(-t,-s)]

    write_safe(
        x = x[c(t,s, others)],
        path = path
    )
}


#' Write to csv
#'
#' This function will use the readr version of write_csv
#' if it can be found, and will fall back to write.csv
#' from base if not. This allows me to keep the number
#' of dependencies low.
write_safe <- function(x, path, na = ""){
    if(requireNamespace("readr", quietly = TRUE)){
        readr::write_csv(x = x, path = path, na = na)
    }else{
        write.csv(x = x, file = path, na = na)
    }
}
