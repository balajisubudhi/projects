##This should detect and install missing packages before loading them - hopefully!
 
list.of.packages <- c("shiny","ggmap","googleVis")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages,function(x){library(x,character.only=TRUE)})

data1 = read.csv("data1.csv", header = TRUE, sep = ",")
data1$Source = paste(data1$SLat, ":", data1$SLong, sep = "")

df <- data.frame(Postcode=c("EC3M 7HA", "EC2P 2EJ"),
                 Tip=c("<a href='http://www.lloyds.com'>Lloyd's</a>",
                 "<a href='http://www.guildhall.cityoflondon.gov.uk/'>Guildhall</a>"))

 