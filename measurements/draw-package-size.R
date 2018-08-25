#!/usr/bin/env Rscript

library("ggplot2", lib=".r-stuff/")
library("labeling", lib=".r-stuff/")
library("digest", lib=".r-stuff/")

theme_set(theme_minimal())

format_bytes <- function(...) {
  function(x) {
    limits <- c(1e0, 1e3, 1e6)
    prefix <- c(" ", "k", "M")

    i <- findInterval(abs(x), limits)
    i <- ifelse(i == 0, which(limits == 1e0), i)

    paste(format(round(x / limits[i], 1), trim = TRUE, scientific = FALSE, ...), prefix[i])
  }
}

packageSize <- read.csv("data-package-size.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
packageSize$language <- factor(packageSize$language, levels = packageSize$language[order(packageSize$package_size_in_bytes)])

ggplot(data = packageSize, aes(x = language, y = package_size_in_bytes, fill = platform)) +
  guides(fill = FALSE) +

  geom_bar(stat = "identity", width = .5) +

  labs(title = "Package Size", subtitle = "How big is a package uploaded to the FaaS service?") +

  scale_fill_manual(values = c("slateblue4", "tomato3", "springgreen3", "slategrey", "lightgray")) +

  scale_y_continuous("Package Size [Megabytes]", labels = format_bytes()) +
  scale_x_discrete("Programming Language") +

  theme(axis.text.x = element_text(angle = 65, vjust = 0.5))

ggsave("image-package-size.png")