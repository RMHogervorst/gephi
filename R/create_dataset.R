# create dataset
#
library(magrittr)
library(tidygraph)
graphexample <- tibble::tribble(
    ~from, ~to, ~weight,
    "a","b",1,
    "a","c",1,
    "a","d",1,
    "d","b",1,
    "d","f", 1
) %>%
    tidygraph::as_tbl_graph() %>%
    activate(nodes) %>%
    left_join(
        data.frame(
            name = c("a", "b", "c","d", "f"),
            color = c("blue","blue","blue", "red", "yellow"),
            stringsAsFactors = FALSE
    ))
usethis::use_data(graphexample,overwrite = TRUE)
