options(shiny.maxRequestSize=500*1024^2)

shinyServer(function(input, output) {
  
  # Dashboard 1 analysis in demand for vehicles
  output$Dashboard1 <- renderGvis({
	C1 = gvisMap(data1, "Source", "OrderID",
				options=list(showTip=TRUE, mapType='normal',
				enableScrollWheel=TRUE,
				icons=paste0("{",
				"'Industry': {'Apparel': 'http://icons.iconarchive.com/icons/iconsmind/outline/32/Dress-icon.png',\n",
				"'CPG': 'http://icons.iconarchive.com/icons/robinweatherall/cleaning/32/bottles-icon.png'",
				"}}")))

	return(C1)
  })
})