################################################################################
################################################################################
####    global.R                                                            ####
####    this code will take care of all data operations and functions       ####
################################################################################
################################################################################


library(triangle)
library(googleVis)

firstNames = read.csv("firstNames.csv", header = FALSE, sep = ",")
lastNames = read.csv("lastNames.csv", header = FALSE, sep = ",")
places = read.csv("places.csv", header = FALSE, sep = ",")