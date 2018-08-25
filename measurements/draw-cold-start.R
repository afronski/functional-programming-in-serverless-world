#!/usr/bin/env Rscript

library("ggplot2", lib=".r-stuff/")
library("labeling", lib=".r-stuff/")
library("digest", lib=".r-stuff/")

theme_set(theme_minimal())

format_seconds <- function(...) {
  function(x) {
    limits <- c(1e0)
    prefix <- c("s")

    i <- findInterval(abs(x), limits)
    i <- ifelse(i == 0, which(limits == 1e0), i)

    paste(format(round(x / limits[i], 1), trim = TRUE, scientific = FALSE, ...), prefix[i])
  }
}

rawColdStart <- read.csv("data-cold-start.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)

coldStart <-
  aggregate(
    rawColdStart$time_total,
    by = list(language = rawColdStart$language, platform = rawColdStart$platform),
    FUN = median)

colnames(coldStart) <- c("language", "platform", "time")
coldStart$language <- factor(coldStart$language, levels = coldStart$language[order(coldStart$time)])

ggplot(data = coldStart, aes(x = language, y = time, fill = platform)) +
  guides(fill = FALSE) +

  geom_bar(stat = "identity", width = .5) +

  labs(title = "Startup Time", subtitle = "How slow is the first call of our function (cold start)?") +

  scale_fill_manual(values = c("slateblue4", "tomato3", "springgreen3", "slategrey", "lightgray")) +

  scale_y_continuous("Startup Time [Seconds]", labels = format_seconds()) +
  scale_x_discrete("Programming Language") +

  theme(axis.text.x = element_text(angle = 65, vjust = 0.5))

ggsave("image-cold-start.png")