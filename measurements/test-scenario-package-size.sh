#!/usr/bin/env bash

find ../aws -regex '.*\.\(zip\|jar\)$' -exec du -B1 {} \; | \
sort -h -r                                                | \
awk -f transformation-package-size.awk