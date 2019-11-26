#' Read edges
#'
#' This function reads in an edges csv file exported from gephi into igraph.
#'
#' @param path The file where to read from e.g.: edges.csv or data/edges.csv
#' @param source What column is the source, defaults to 'Source'.
#' @param target What column is the target, defaults to 'Target'.
#' @param directed, is the graph directed or not? defaults to TRUE.
#' @export
#' @family read_graphs
gephi_read_edges_csv <- function(path, source = "Source", target = "Target", directed = TRUE) {
  input <- read_safe(path = path)
  # reorder columns
  other_cols <- colnames(input)[!colnames(input) %in% c(source, target)]
  input <- input[,c(source, target, other_cols)]
  igraph::graph_from_data_frame(input,directed = directed)
}



