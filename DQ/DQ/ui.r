library(shiny)
shinyUI(navbarPage("Data Quality", id = "DQ", inverse = TRUE, collapsable = FALSE,

	tabPanel("Folder Level",
		sidebarPanel(
			#Selector for file upload
			fileInput("datafile", "Choose ZIP file",
					  accept=c("zip", "zip file")),
			h6("After uploading the file go to 'Data Description' tab"),
			br(),
			br(),
			br(),
			br(),
			br(),
			br(),
			tags$head(
						tags$style(type="text/css", "select { width: 200px; }"),
						tags$style(type="text/css", "textarea { max-width: 150px; }"),
						tags$style(type="text/css", ".jslider { max-width: 200px; }"),
						tags$style(type="text/css", ".well { max-width: 250px; }"),
						tags$style(type="text/css", ".span4 { max-width: 250px; }"))),
		htmlOutput("filetable")),
	tabPanel("File Level",
		sidebarPanel(
			#These column selectors are dynamically created when the file is loaded
			uiOutput("toCol")
		),
		htmlOutput("filetable1")),
		#verbatimTextOutput("filetable1")),
	tabPanel("About",htmlOutput("about.html"))
))