##This should detect and install missing packages before loading them - hopefully!
 
list.of.packages <- c("shiny","ggmap","googleVis")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages,function(x){library(x,character.only=TRUE)})

read_zip=function()
{
	
}

read_dates=function(column)
{
	
}
 