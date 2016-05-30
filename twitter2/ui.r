################################################################################
################################################################################
####    ui.R                                                                ####
####    this code will take care of all UI views                            ####
################################################################################
################################################################################
library(DT)
dashboardPage(skin = "blue", 
  dashboardHeader(title = "TWITTER ANALYSIS"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Download Twitter Data", tabName = "createData", icon = icon("twitter")),
	  menuItem("Analyse Twitter", tabName = "analyseData", icon = icon("twitter")),
	  menuItem("Compare Over Twitter", tabName = "compare", icon = icon("twitter"))
    )
  ),
  dashboardBody(
	tabItems(
	###################################################################################################
	######## code for first dashboard to download twitter data ########################################
	###################################################################################################
		tabItem(tabName = "createData",
			h3("Download data frome Twitter"),
			# Boxes need to be put in a row (or column)
			fluidRow(height = 10, 
				box(width = 4, background = "teal",
					textInput("entity", "Enter the keyword or #tag", value = "modi"),
					actionButton("tweet", "Fetch Tweets")
				),
				box(width = 4, background = "teal",
					sliderInput("nTweet", "No of recent tweets to fetch", min = 50, max = 1000, value = 100, step = 25, round = FALSE)			
				),
				box(width = 4, background = "teal",
					textInput("fileName", "Please name the file", value = "tweetData"),
					downloadButton("downloadData", "Download")
				)
			),
			fluidRow(height = 10,
				valueBoxOutput("tweetCount", width = 3),
				valueBoxOutput("uniqueTweets", width = 3),
				valueBoxOutput("userCount", width = 3),
				valueBoxOutput("loactionCount", width = 3)
			),
			fluidRow(box(title = "Raw tweet info", width = 12, dataTableOutput("tweetTable")))
		),
	###################################################################################################
	######## code for 2nd dashboard to analyse twitter data ###########################################
	###################################################################################################
		tabItem(tabName = "analyseData", height = 15,
			h3("Analyse Twitter Data"),
			fluidRow(height = 10,
				valueBoxOutput("entityName", width = 2),
				valueBoxOutput("tweetCount1", width = 2),
				valueBoxOutput("uniqueTweets1", width = 2),
				valueBoxOutput("retweets", width = 2),
				valueBoxOutput("userCount1", width = 2),
				valueBoxOutput("loactionCount1", width = 2)
			),
			tabsetPanel(
				tabPanel("Tweet Analysis", height = 12,
					box(title = "Sentiment Bar Chart",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiBar")),
					box(title = "Sentiment Scatter Chart",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiScatter")),
					box(title = "Word Cloud",
						width = 6, background = "green",
						plotOutput("wordCloud"), height = 200),
					box(title = "Extreme Tweets",
						width = 6, background = "green",
						htmlOutput(outputId = "extremeTweets"))					
				),
				tabPanel("Keyword Analysis", 
					box(title = "Sentiment Bar Chart",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiBar1")),
					box(title = "Sentiment Scatter Chart",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiScatter11")),
					box(title = "Word Cloud",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiScatter21")),
					box(title = "Sentiment Bar Chart",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiScatter31"))
				),
				tabPanel("User Analysis", 
					box(title = "Sentiment Bar Chart",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiBar2")),
					box(title = "Sentiment Scatter Chart",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiScatter12")),
					box(title = "Word Cloud",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiScatter22")),
					box(title = "Sentiment Bar Chart",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiScatter32"))
				),
				tabPanel("Location Analysis",
					box(title = "Sentiment Bar Chart",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiBar3")),
					box(title = "Sentiment Scatter Chart",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiScatter13")),
					box(title = "Word Cloud",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiScatter23")),
					box(title = "Sentiment Bar Chart",
						width = 6, background = "green",
						htmlOutput(outputId = "sentiScatter33"))
				)
			)
		)
	)
  )
)