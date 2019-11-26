# test outputfile
context("testing output of csv files")

## create the file we need

test_that("edgefile has correct columns", {

  # create edgefile
  edgefilelocation <- "edgefile.csv"
  gephi_write_edges(graphexample, path = edgefilelocation)
  # read the file in
  read_edgefile <- utils::read.csv(edgefilelocation)

  # now the testing is started
  expect_true(all(names(read_edgefile)[1:2] == c("Source", "Target")))
})

context("testing convertion to igraph")

test_that("correct igraph object is created", {
  # read it in.
  edgefilelocation <- "edgefile.csv"
  gephi_write_edges(graphexample, path = edgefilelocation)
  graph_csv <- gephi_read_edges_csv(edgefilelocation, source = "Source", target = "Target")
  temp <- gephi::graphexample
  igraph::E(temp)$weight <- c(1,1,1,1,1)
  temp <- igraph::delete_vertex_attr(graph = temp, name = "color")
  expect_true(igraph::identical_graphs(temp, graph_csv))

  rm(graph_csv)
})

