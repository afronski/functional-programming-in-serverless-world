#!/usr/bin/env Rscript

dir.create(".r-stuff/", showWarnings = FALSE, recursive = TRUE)

options(repos = structure(c(CRAN = "https://ftp.fau.de/cran/")))

install.packages("pillar", dependencies = TRUE, lib=".r-stuff/")
install.packages("crayon", dependencies = TRUE, lib=".r-stuff/")
install.packages("ggplot2", dependencies = TRUE, lib=".r-stuff/")
install.packages("labeling", dependencies = TRUE, lib=".r-stuff/")
install.packages("digest", dependencies = TRUE, lib=".r-stuff/")
