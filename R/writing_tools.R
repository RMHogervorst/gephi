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
#' @noRd
write_safe <- function(x, path, na = ""){
    if(requireNamespace("readr", quietly = TRUE)){
        readr::write_csv(x = x, path = path, na = na)
    }else{
        write.csv(x = x, file = path, na = na)
    }
}


#' Write igraph/ tidygraph to a format that gephi can read
#'
#' write_nodes will write the nodes, and write_edges will write
#' the edges to a csv file. You will alway want to use the write_edges
#' function, the write nodes function has only added value if the nodes
#' have attributes, such as Label, Age, color etc.
#'
#' If the file is not an igraph / tidygraph object, but a dataframe
#' you could use the write_*_from_df functions. This function will
#' assume the edges are between the first and second column, but you can
#' specify if that is not the case.
#'
#' @family extractors
#' @export
gephi_write_nodes <- function(graph, path, na = "", verbose = TRUE){
    result <- igraph::get.data.frame(graph, what = "nodes")
    names(result)[1] <- "Id"
    if(verbose){message(paste0("writing nodes",deparse(substitute(graph)),"\nto nodefile: ",path) )}
    write_safe(result, path, na = na)
}

#' @describeIn gephi_write_nodes
#' @export
gephi_write_edges <- function(graph, path,na = "", verbose = TRUE){
    result <- igraph::get.data.frame(graph, what = "edges")
    names(result)[1:2] <- c("Source", "Target")
    if(verbose){message(paste0("writing edges",deparse(substitute(graph)),"\nto edgefile: ",path) )}
    write_safe(result, path, na = na)
}

#' @describeIn gephi_write_nodes
#' @export
gephi_write_both <- function(graph, pathedges, pathnodes, na = "", verbose = TRUE){
    gephi_write_edges(graph = graph, path = pathedges, na = na, verbose = verbose)
    gephi_write_nodes(graph = graph, path = pathnodes, na = na, verbose = verbose)
}

#' @describeIn gephi_write_nodes
gephi_write_edges_from_df <- function(dataframe, from = NULL, to = NULL, path, na = "",verbose = TRUE){
    df_names <- names(dataframe)
    if(is.null(from)){
        from_ind <- 1
    }else{
        from_ind <- grep(from, df_names)[[1]]
    }
    df_names[from_ind] <- "Source"
    if(is.null(to)){
        to_ind <- 2
    }else{
        to_ind <- grep(to, df_names)[[1]]
    }
    df_names[to_ind] <- "Target"
    names(dataframe) <- df_names
    if(verbose){message(paste0("writing edges from dataframe",deparse(substitute(dataframe)),"\nto edgefile: ",path) )}
    write_safe(dataframe, path = path, na = na)
}
