# test outputfile
context("testing output of csv files")

## create the file we need

test_that("edgefile has correct columns", {

    # create edgefile
    edgefilelocation <- "edgefile.csv"
    gephi_write_edges(graphexample, path = edgefilelocation)
    # read the file in
    read_edgefile <- read.csv(edgefilelocation)
    file.remove(edgefilelocation)
    # now the testing is started
    expect_true(all(names(read_edgefile)[1:2] == c( "Source","Target")))
})
