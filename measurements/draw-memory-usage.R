#!/usr/bin/env Rscript

library("ggplot2", lib=".r-stuff/")
library("labeling", lib=".r-stuff/")
library("digest", lib=".r-stuff/")

theme_set(theme_minimal())

format_megabytes <- function(...) {
  function(x) {
    limits <- c(1e0, 1e3)
    prefix <- c("M", "G")

    i <- findInterval(abs(x), limits)
    i <- ifelse(i == 0, which(limits == 1e0), i)

    paste(format(round(x / limits[i], 1), trim = TRUE, scientific = FALSE, ...), prefix[i])
  }
}

memoryUsage <- read.csv("data-memory-usage.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
memoryUsage$number <- as.factor(memoryUsage$number)

ggplot(data = memoryUsage, aes(x = number, y = memory, fill = language, group = memory)) +
  geom_bar(stat = "identity", width = 0.7, position = position_dodge()) +

  geom_text(aes(2, 256, label = "Memory Limit (256 MB)", vjust = -1, color = "red"), size = 2, show.legend = FALSE) +
  geom_hline(yintercept = 256, color = "red", linetype = "dashed", show.legend = FALSE) +

  labs(title = "Memory Usage", subtitle = "How much memory was allocated for a specific request?") +

  scale_fill_manual(
    guide = guide_legend(title = NULL),
    values = c("olivedrab2", "rosybrown", "seagreen4", "slateblue4", "slategrey", "springgreen1", "tomato2")) +

  scale_y_continuous("Memory [Megabytes]", labels = format_megabytes()) +
  scale_x_discrete("Generating primes up to this value") +

  theme(axis.text.x = element_text(angle = 65, vjust = 0.5))

ggsave("image-memory-usage.png")