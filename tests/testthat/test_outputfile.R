# test outputfile
context("testing output of csv files")

## create the file we need

test_that("edgefile has correct columns", {

    # create edgefile
    edgefilelocation <- "edgefile.csv"
    gephi_write_edges(graphexample, path = edgefilelocation)
    # read the file in
    read_edgefile <- read.csv(edgefilelocation)

    # now the testing is started
    expect_true(all(names(read_edgefile)[1:2] == c( "Source","Target")))
})

context("testing convertion to igraph")

test_that("correct igraph object is created", {
    # read it in.
    graph_csv <- gephi_read_edges_csv(edgefilelocation, source = "Source", target = "Target")
    expect_true(igraph::identical_graphs(gephi::graphexample, graph_csv))

    rm(graph_csv)
})


file.remove(edgefilelocation)
