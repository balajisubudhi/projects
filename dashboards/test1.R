library(leaflet)
library(magrittr)
setwd("D:\\kaggel\\majro\\dashboards\\app2")

data1 = read.csv("data1.csv", header = TRUE, sep = ",")
data1$Source = paste(data1$SLat, ":", data1$SLong, sep = "")
data1[1, "Industry"] = "Apparel"
data1$DateTime = as.POSIXct(data1$DateTime, format="%m/%d/%y %H:%M")

icons <- iconList(
  Apparel = makeIcon("http://icons.iconarchive.com/icons/iconsmind/outline/128/Dress-icon.png", 36, 36),
  CPG = makeIcon("http://icons.iconarchive.com/icons/iconsmind/outline/128/Milk-Bottle-icon.png", 36, 36),
  Electricals = makeIcon("http://icons.iconarchive.com/icons/double-j-design/electronics/128/SOT-6-pin-icon.png", 36, 36),
  HomeFurniture = makeIcon("http://icons.iconarchive.com/icons/icons8/ios7/128/Household-Armchair-icon.png", 36, 36),
  PackagedFood = makeIcon("http://icons.iconarchive.com/icons/icons8/ios7/128/Food-Lamb-Rack-icon.png", 36, 36),
  Pharma = makeIcon("http://icons.iconarchive.com/icons/iconsmind/outline/128/Medicine-2-icon.png", 36, 36)
)

maps = leaflet(data = data1[1:100,]) %>% 
  addTiles() %>%
  addMarkers(~SLong, ~SLat, popup = ~as.character(Industry), icon = ~icons[Industry])
maps


 