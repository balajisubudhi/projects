################################################################################
################################################################################
####    global.R                                                            ####
####    this code will take care of all data operations and functions       ####
################################################################################
################################################################################

library(googleVis)
library(leaflet)

data1 = read.csv("data1.csv", header = TRUE, sep = ",")
data1$DateTime = as.POSIXct(data1$DateTime, format="%Y-%m-%d %H:%M")