################################################################################
################################################################################
####    ui.R                                                                ####
####    this code will take care of all UI views                            ####
################################################################################
################################################################################

library(shiny)
library(shinydashboard)
library(DT)
dashboardPage(skin = "black", 
  dashboardHeader(title = "DATA GENERATION"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Create Data", tabName = "Create Data", icon = icon("database"))
      #menuItem("Analyse Data", tabName = "Analyse Data", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(height = 12, column(width = 3,
      box(background = "light-blue", width = NULL,
		textInput("colName", "Please name the column", value = "Variable"),
		numericInput("noRows", "Please enter no of rows", value = "", 
								min = 0, max = 50000, step = NA),
		selectInput("datatype", "Select type of data", 
					c("Numeric" = "numeric",
					"Character" = "character",
					"Date" = "date"), 
					selected = "", multiple = FALSE),
		conditionalPanel(
			condition = "input.datatype == 'numeric'",
			selectInput("distribution", "Select distribution", 
						c("Normal Distribution" = "normal",
						"Uniform Distribution" = "uniform",
						"Triangular Distribution" = "triangular",
						"Exponential Distribution" = "exponential",
						"Random Distribution" = "random",
						"Sequential Numbers" = "sequential"), 
						selected = "Normal Distribution", multiple = FALSE),
			conditionalPanel(
				condition = "input.distribution == 'normal'",
				numericInput("normalmean", "Mean", value = 10, 
									min = NA, max = NA, step = NA),
				numericInput("normalsd", "Standard Deviation", value = 5, 
									min = NA, max = NA, step = NA)
				),
			conditionalPanel(
				condition = "input.distribution == 'uniform'",
				numericInput("uniformmin", "Minimum No", value = 0, 
									min = NA, max = NA, step = NA),
				numericInput("uniformmax", "Maximum No", value = 10, 
									min = NA, max = NA, step = NA)
				),
			conditionalPanel(
				condition = "input.distribution == 'triangular'",
				numericInput("triangularmin", "Minimum No", value = 0, 
									min = NA, max = NA, step = NA),
				numericInput("triangularmax", "Maximum No", value = 10, 
									min = NA, max = NA, step = NA)
				),
			conditionalPanel(
				condition = "input.distribution == 'exponential'",
				numericInput("exponentialrate", "Rate", value = 1, 
									min = NA, max = NA, step = NA)
				),
			conditionalPanel(
				condition = "input.distribution == 'random'",
				numericInput("randommin", "Minimum No", value = 0, 
									min = NA, max = NA, step = NA),
				numericInput("randommax", "Maximum No", value = 10, 
									min = NA, max = NA, step = NA)
				),
				conditionalPanel(
				condition = "input.distribution == 'sequential'",
				numericInput("sequentialmin", "Start No", value = 1, 
									min = NA, max = NA, step = NA)
				)),
		conditionalPanel(
			condition = "input.datatype == 'character'",
			selectInput("characterType", "Select Variable", 
						c("First Name" = "fName",
						"Last Name" = "lName",
						"Place" = "place",
						"Factor" = "factor"), 
						selected = "", multiple = FALSE),
			conditionalPanel(
				condition = "input.characterType == 'factor'",
				textInput("factors", "Enter factor values seperated by ','", value = "x, y, z"))),
		conditionalPanel(
			condition = "input.datatype == 'date'",
			selectInput("dateType", "Select date type", 
						c("Only Date" = "oDate",
						"Date & Time" = "dateTime",
						"Time Stamp" = "timeStamp"), 
						selected = "Only Date", multiple = FALSE),
			conditionalPanel(
				condition = "input.dateType == 'oDate'",
				dateInput("sDate", "Start Date"),
				dateInput("eDate", "End Date")),
			conditionalPanel(
				condition = "input.dateType == 'dateTime'",
				dateInput("sDate", "Start Date"),
				dateInput("eDate", "End Date"),
				numericInput("sHour", "Enter Start Hour", value = 8, 
									min = 0, max = 24, step = NA),
				numericInput("eHour", "Enter End Hour", value = 20, 
									min = 0, max = 24, step = NA)),
			conditionalPanel(
				condition = "input.dateType == 'timeStamp'",
				dateInput("sDate", "Start Date"),
				dateInput("eDate", "End Date"),
				numericInput("sHour", "Enter Start Hour", value = 8, 
									min = 0, max = 24, step = NA),
				numericInput("eHour", "Enter End Hour", value = 20, 
									min = 0, max = 24, step = NA))),
		actionButton("goButton", "Generate Column"))
	  ),
	  column(width = 8,
		fluidRow(
			box(width = 4, background = "light-blue",
				htmlOutput("viz")
				),
			box(width = 4, background = "red",
				uiOutput("toCol"),
				actionButton("delete", "Delete Column")
				),
			box(width = 4, background = "blue",
				textInput("fileName", "Please name the file", value = "randomData"),
				downloadButton("downloadData", "Download")
				)
			),
		fluidRow(box(width = 12,dataTableOutput("opTable")))
	  )
	)
  )
)
