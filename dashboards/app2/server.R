################################################################################
################################################################################
####    server.R                                                            ####
####    this code will take care of all data manipulation                   ####
################################################################################
################################################################################
options(shiny.maxRequestSize=100*1024^8)
function(input, output) {
	###################################################################################################
	######## code for first dashboard for demand on map        ########################################
	###################################################################################################
	
	#render the info boxs
	output$orderCount = renderValueBox({
		valueBox(nrow(data1), "no of orders", icon = icon("edit"), color = "navy")
	})
	output$industryCount = renderValueBox({
		valueBox(length(unique(data1$Industry)), "Unique Industry", icon = icon("gears"), color = "navy")
	})
	output$xCount = renderValueBox({
		valueBox(sum(data1$Quantity), "count of X", icon = icon("suitcase"),	color = "navy")
	})
	output$vehicleCount = renderValueBox({
		valueBox(nrow(data1), "no of vehicles", icon = icon("bus"), color = "navy")
	})
	requiredData = subset
	icons <- iconList(
	  Apparel = makeIcon("http://icons.iconarchive.com/icons/iconsmind/outline/128/Dress-icon.png", 30, 30),
	  CPG = makeIcon("http://icons.iconarchive.com/icons/iconsmind/outline/128/Milk-Bottle-icon.png", 30, 30),
	  Electricals = makeIcon("http://icons.iconarchive.com/icons/double-j-design/electronics/128/SOT-6-pin-icon.png", 30, 30),
	  HomeFurniture = makeIcon("http://icons.iconarchive.com/icons/icons8/ios7/128/Household-Armchair-icon.png", 30, 30),
	  PackagedFood = makeIcon("http://icons.iconarchive.com/icons/icons8/ios7/128/Food-Lamb-Rack-icon.png", 30, 30),
	  Pharma = makeIcon("http://icons.iconarchive.com/icons/iconsmind/outline/128/Medicine-2-icon.png", 30, 30)
	)
	data2 = subset(data1, format(data1$DateTime, "%Y-%m-%d") == format(input$inputDate, "%Y-%m-%d"),)
	output$mymap <- renderLeaflet({
		  leaflet(data = data2) %>% 
		  addTiles() %>%
		  addMarkers(~SLong, ~SLat, popup = ~as.character(Industry), icon = ~icons[Industry])
	  })
}
