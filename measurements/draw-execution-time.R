#!/usr/bin/env Rscript

library("crayon", lib=".r-stuff/")
library("pillar", lib=".r-stuff/")
library("withr", lib=".r-stuff/")
library("ggplot2", lib=".r-stuff/")
library("labeling", lib=".r-stuff/")
library("digest", lib=".r-stuff/")

theme_set(theme_minimal())

format_milliseconds <- function(...) {
  function(x) {
    limits <- c( 1e0, 1e3)
    prefix <- c("ms", "s")

    i <- findInterval(abs(x), limits)
    i <- ifelse(i == 0, which(limits == 1e0), i)

    paste(format(round(x / limits[i], 1), trim = TRUE, scientific = FALSE, ...), prefix[i])
  }
}

executionTime <- read.csv("data-execution-time.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
executionTime$number <- as.factor(executionTime$number)

ggplot(data = executionTime, aes(x = number, y = time, fill = language, group = time)) +
  geom_bar(stat = "identity", width = 0.7, position = position_dodge()) +

  geom_text(aes(2, 20000, label = "Execution time limit (20 s)", vjust = -1, color = "red"), size = 2, show.legend = FALSE) +
  geom_hline(yintercept = 20000, color = "red", linetype = "dashed", show.legend = FALSE) +

  labs(title = "Execution Time", subtitle = "How long code ran for a specific request?") +

  scale_fill_manual(
    guide = guide_legend(title = NULL),
    values = c("olivedrab2", "rosybrown", "seagreen4", "slateblue4", "slategrey", "springgreen1", "tomato2")) +

  scale_y_continuous("Execution Time [Milliseconds]", labels = format_milliseconds()) +
  scale_x_discrete("Generating primes up to this value") +

  theme(axis.text.x = element_text(angle = 65, vjust = 0.5))

ggsave("image-execution-time.png")
