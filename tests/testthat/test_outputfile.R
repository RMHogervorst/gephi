# test outputfile
context("testing output of csv files")

## create the file we need

test_that("edgefile has correct columns", {

    # create edgefile
    edgefilelocation <- "edgefile.csv"
    write_edgefile(x = graphexample, path = edgefilelocation)
    # read the file in
    read_edgefile <- read.csv(edgefilelocation)
    file.remove(edgefilelocation)
    # now the testing is started
    expect_match(names(read_edgefile)[1:2,], c("Target", "Source"))
})
