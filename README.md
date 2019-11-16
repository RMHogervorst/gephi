
<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](http://choosealicense.com/)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![codecov](https://codecov.io/gh/RMHogervorst/gephi/branch/master/graph/badge.svg)](https://codecov.io/gh/RMHogervorst/gephi)
[![Build
Status](https://travis-ci.org/RMHogervorst/gephi.svg?branch=master)](https://travis-ci.org/RMHogervorst/gephi)

<!-- badges: end -->

<!-- README.md is generated from README.Rmd. Please edit that file -->

# gephi

This is a simple package to export files into a csv format that gephi
can understand. This package does not interface with the open source
network vizualisation software gephi but it writes and reads in the same
csv format as gephi.

I’ve found the need to convert tidygraph/igraph objects into a node and
edge csv, to visualize in gephi quite often. This should be trivial, but
gephi is a bit particular and wants specific column names.

## What does the package do?

Writes igraph files to csv format that gephi likes. Really? Gephi reads
csv files just fine\! Sure but it wants the columns in a particular
order and named Source, Target etc. Let’s not do this by hand everytime:
AUTOMATE THE BORING STUFF\! HACK THE PLANET\!

## Installation

Install this developmental version with:

``` r
# install.packages("devtools")
devtools::install_github("RMHogervorst/gephi")
```

## Example

  - igraph to csv
  - tidygraph to csv
  - dataframe to csv

Writing out an igraph file to csv:

``` r
library(gephi) # includes the graphexample file
library(igraph)
#> 
#> Attaching package: 'igraph'
#> The following objects are masked from 'package:stats':
#> 
#>     decompose, spectrum
#> The following object is masked from 'package:base':
#> 
#>     union
V(graphexample)
#> + 5/5 vertices, named, from c4d510b:
#> [1] a d b c f
E(graphexample)
#> + 5/5 edges from c4d510b (vertex names):
#> [1] a->b a->c a->d d->b d->f
gephi_write_edges(graphexample, "edges.csv")
#> writing edgesgraphexample
#> to edgefile: edges.csv/n
```

Technically an tidygraph object is also an igraph object so the writing
will work the same.

``` r
library(gephi)
library(tidygraph)
#> 
#> Attaching package: 'tidygraph'
#> The following object is masked from 'package:igraph':
#> 
#>     groups
#> The following object is masked from 'package:stats':
#> 
#>     filter

(tidy_graphexample <- tidygraph::as_tbl_graph(graphexample)) # Just to show where this function comes from
#> # A tbl_graph: 5 nodes and 5 edges
#> #
#> # A directed acyclic simple graph with 1 component
#> #
#> # Node Data: 5 x 2 (active)
#>   name  color 
#>   <chr> <chr> 
#> 1 a     blue  
#> 2 d     red   
#> 3 b     blue  
#> 4 c     blue  
#> 5 f     yellow
#> #
#> # Edge Data: 5 x 3
#>    from    to weight
#>   <int> <int>  <dbl>
#> 1     1     3      1
#> 2     1     4      1
#> 3     1     2      1
#> # … with 2 more rows
```

More specifically if you want to modify your graph and visualize a
subset in gephi, here is a tidygraph worked example where I select only
the edges that are blue, add a new edge property and write the resuling
graph to the :

``` r
tidy_graphexample %>%  # but the igraph object works just as well
    activate(nodes) %>% 
    filter(color == "blue") %>% 
    activate(edges) %>% 
    mutate(dongle = "dingle") %>% 
    gephi_write_edges("edges_subset.csv") %>% 
    print()
#> writing edges.
#> to edgefile: edges_subset.csv/n
#> # A tbl_graph: 3 nodes and 2 edges
#> #
#> # A rooted tree
#> #
#> # Edge Data: 2 x 4 (active)
#>    from    to weight dongle
#>   <int> <int>  <dbl> <chr> 
#> 1     1     2      1 dingle
#> 2     1     3      1 dingle
#> #
#> # Node Data: 3 x 2
#>   name  color
#>   <chr> <chr>
#> 1 a     blue 
#> 2 b     blue 
#> 3 c     blue
```

But is is also possible to write a set of edges when there is no graph
object, just a dataframe.

``` r
a_nice_df <- data.frame(
    start = c(1,2,3,4,5,6,7),
    finish = c(2,4,4,7,2,1,3),
    weight = c(1,1,1,2,6,1,1)
)
print(a_nice_df) 
#>   start finish weight
#> 1     1      2      1
#> 2     2      4      1
#> 3     3      4      1
#> 4     4      7      2
#> 5     5      2      6
#> 6     6      1      1
#> 7     7      3      1
gephi_write_edges_from_df(a_nice_df, path = "edges2.csv")
#> writing edges from dataframe to edgefile: edges2.csv
```

<details>

<summary> Test coverage statistics </summary>

``` r
covr::package_coverage(type = "tests")
#> gephi Coverage: 30.00%
#> R/writing_tools.R: 18.75%
#> R/utils.R: 66.67%
#> R/read_tools.R: 100.00%
```

</details>

``` r
file.remove("edges.csv")
#> [1] TRUE
file.remove("edges2.csv")
#> [1] TRUE
file.remove("edges_subset.csv")
#> [1] TRUE
```

# Links

  - [Gephi website](https://gephi.org/)
