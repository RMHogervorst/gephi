
#' Read edges
#'
#' @export
#' @family read_graphs
gephi_read_edges_csv <- function(path, source = "Source", target = "Target", directed = TRUE) {
  input <- read_safe(path = path)
  # rename to source and target? (edgelist in first 2 columsn)
  igraph::graph_from_data_frame(input)
}
