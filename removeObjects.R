# This is a script to remove all the objects from R memory to start every Rmd file from fresh

rm(list = ls())

# I also set knitr options here

knitr::opts_chunk$set(message = FALSE)
knitr::opts_chunk$set(warning = FALSE)
knitr::opts_chunk$set(cache = TRUE)

