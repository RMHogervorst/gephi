context("read in files from gephi")

test_that("file reading returns graph we like", {
    edgefilelocation <- "edgefile.csv"
    graph <- gephi_read_edges_csv(edgefilelocation)
    expect_equal(igraph::ecount(graph), 5)
    expect_equal(igraph::vcount(graph), 5)
})

