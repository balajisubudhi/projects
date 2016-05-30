library(shiny)
shinyUI(navbarPage("MOJRO", id = "MOJRO", inverse = TRUE, collapsable = FALSE, position = c("static-top", "fixed-top", "fixed-bottom"),
	tabPanel("Dashboard1", img(src= "pp.jpg", height=140, width=146, align = "right"),
		sidebarPanel(
			#Selector for file upload
			dateInput("inputDate", "Enter Date", value = "2016-05-06", min = "2016-05-04", 
									max = "2016-05-07", format = "yyyy-mm-dd",
									startview = "month", language = "en"),
			sliderInput("inputTime", "Select Time Band", min = 0, max = 24, 
									value = c(6,9), step = 3, round = TRUE),
			tags$head(
						tags$style(type="text/css", "select { width: 200px; }"),
						tags$style(type="text/css", "textarea { max-width: 150px; }"),
						tags$style(type="text/css", ".jslider { max-width: 200px; }"),
						tags$style(type="text/css", ".well { max-width: 250px; }"),
						tags$style(type="text/css", ".span4 { max-width: 250px; }"))),
		htmlOutput("Dashboard1")),
	tabPanel("Dashboard2", img(src= "pp.jpg", height=140, width=146, align = "right"),
		sidebarPanel(
			#Selector for file upload
			dateInput("inputDate", "Enter Date", value = "2016-05-06", min = "2016-05-04", 
									max = "2016-05-07", format = "yyyy-mm-dd",
									startview = "month", language = "en"),
			sliderInput("inputTime", "Select Time Band", min = 0, max = 24, 
									value = c(6,9), step = 3, round = TRUE)),
		htmlOutput("filetable1")),
		#verbatimTextOutput("filetable1")),
	tabPanel("Dashboard3", img(src= "pp.jpg", height=140, width=146, align = "right"),
	htmlOutput("about.html"))
))
