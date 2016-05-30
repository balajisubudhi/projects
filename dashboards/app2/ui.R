################################################################################
################################################################################
####    ui.R                                                                ####
####    this code will take care of all UI views                            ####
################################################################################
################################################################################

library(shiny)
library(shinydashboard)
dashboardPage(skin = "yellow", 
  dashboardHeader(title = "MOJRO"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("DashBoard1", tabName = "DashBoard1", icon = icon("dashboard")),
	  menuItem("DashBoard2", tabName = "DashBoard2", icon = icon("dashboard")),
	  menuItem("DashBoard3", tabName = "DashBoard3", icon = icon("dashboard"))
    )
  ),  
dashboardBody(
tabItems(
###################################################################################################
######## code for first dashboard for demand on map        ########################################
###################################################################################################
	tabItem(tabName = "DashBoard1",
		h3("Orders on the map"),
		# Boxes need to be put in a row (or column)
		fluidRow(height = 10, 
			box(width = 4, background = "teal", height = 120,
				dateInput("inputDate", "Enter Date", value = "2016-05-06", min = "2016-05-04", 
									max = "2016-05-07", format = "yyyy-mm-dd",
									startview = "month", language = "en")
			),
			box(width = 8, background = "teal",
				sliderInput("inputTime", "Select Time Band", min = 0, max = 24, 
									value = c(6,9), step = 3, round = TRUE)			
			)
		),
		fluidRow(height = 10,
			valueBoxOutput("orderCount", width = 3),
			valueBoxOutput("industryCount", width = 3),
			valueBoxOutput("xCount", width = 3),
			valueBoxOutput("vehicleCount", width = 3)
		),
		fluidRow(box(width = 12, leafletOutput("mymap")))
	)))
)
