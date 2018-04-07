# test outputfile
context("testing output of csv files")

## create the file we need

test_that("edgefile has correct columns", {
    # create file
    testdir <- tempdir()
    # create edgefile

    edgefilelocation <- "edgefile.csv"
    #
    write_edgefile(x = testingedgeframe, path = edgefilelocation)
    read_edgefile <- read.csv(edgefilelocation)
    # now the testing is started
    expect_match(names(read_edgefile)[1:2,], c("Target", "Source"))
})
