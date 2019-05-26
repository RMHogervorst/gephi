# Write edgefile to csv
# write_edgefile <- function(x, path, Weight = NULL, Type = NULL){
#     # reset column order?
#     # (Target, Source, *Weight, *Type)
#     # deal with possible type?
#     stopifnot(is.data.frame(x))
#     oldorder <- names(x)
#     t <- grep("Target", oldorder)
#     s <- grep("Source", oldorder)
#     others <- seq_len(NCOL(x))[c(-t,-s)]
#
#     write_safe(
#         x = x[c(t,s, others)],
#         path = path
#     )
# }
#



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
#' @param graph The igraph or tidygraph object your work  with
#' @param path the file where to save to e.g.: edges.csv or data/edges.csv
#' @param na How to record missing values, defaults to "", nothing / empty values
#' @param verbose by default these functions are chatty and will tell you what they do if you do not want that, set to FALSE
#' @param pathedges where to save the edges file e.g.: 'edges.csv'
#' @param pathnodes where to save the nodes file e.g.: 'nodes.csv'
#' @return invisible original object so you could continue using it in a pipe if you want to
#' @export
#' @family write_graphs
gephi_write_nodes <- function(graph, path, na = "", verbose = TRUE) {
  result <- igraph::get.data.frame(graph, what = "nodes")
  names(result)[1] <- "Id"
  if (verbose) {
    message(paste0("writing nodes", deparse(substitute(graph)), "\nto nodefile: ", path, "/n"))
  }
  write_safe(result, path, na = na)
  return(invisible(graph))
}

#' @describeIn gephi_write_nodes Write nodes data to csv
#' @export
gephi_write_edges <- function(graph, path, na = "", verbose = TRUE) {
  result <- igraph::get.data.frame(graph, what = "edges")
  names(result)[1:2] <- c("Source", "Target")
  if (verbose) {
    message(paste0("writing edges", deparse(substitute(graph)), "\nto edgefile: ", path, "/n"))
  }
  write_safe(result, path, na = na)
  return(invisible(graph))
}

#' @describeIn gephi_write_nodes Write both node and edge data away
#' @export
gephi_write_both <- function(graph, pathedges, pathnodes, na = "", verbose = TRUE) {
  gephi_write_edges(graph = graph, path = pathedges, na = na, verbose = verbose)
  gephi_write_nodes(graph = graph, path = pathnodes, na = na, verbose = verbose)
  return(invisible(graph))
}

#' Write edges from a data.frame to a file
#'
#' If you have a dataframe that represents a graph and you don't want to turn it
#' into an igraph/tidygraph object first, this function will turn it into a csv.
#' Give the column name where the edges start and the column name of the edge
#' end. If you don't specify it, this function expects the first column to be a
#' the start and second column the end point of an edge.
#' @param dataframe which dataframe
#' @param from which column does the edge start
#' @param to which column does the edge end
#' @inheritParams gephi_write_nodes
#' @return invisible original object so you could continue using it in a pipe if you want to
#' @export
#' @family write_graphs
gephi_write_edges_from_df <- function(dataframe, from = NULL, to = NULL, path, na = "", verbose = TRUE) {
  df_names <- names(dataframe)
  if (is.null(from)) {
    from_ind <- 1
  } else {
    from_ind <- grep(from, df_names)[[1]]
  }
  df_names[from_ind] <- "Source"
  if (is.null(to)) {
    to_ind <- 2
  } else {
    to_ind <- grep(to, df_names)[[1]]
  }
  df_names[to_ind] <- "Target"
  names(dataframe) <- df_names
  if (verbose) {
    message(paste0(
      "writing edges from dataframe ",
      "to edgefile: ", path, "\n"
    ))
  }
  write_safe(dataframe, path = path, na = na)
  return(invisible(dataframe))
}
