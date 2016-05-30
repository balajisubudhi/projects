################################################################################
################################################################################
####    global.R                                                            ####
####    this code will take care of all standard functions and libraries    ####
################################################################################
################################################################################
# call all required libraries
library("twitteR")
library("stringr")
library("ROAuth")
library("RCurl")
library("ggplot2")
library("reshape")
library("tm")
library("RJSONIO")
library("wordcloud")
library("gridExtra")
library("plyr")
library("shiny")
library("shinydashboard")
library("qdap")
library("googleVis")

# A credential obtained from twitter permitting access to their data - A user will need this to proceed
load("D:\\github\\twitter2\\twitter authentication.Rdata") 
registerTwitterOAuth(cred)

# Convert tweets from list to data frame
tweetToDF = function(tweetLst)
{
	twtList1 = do.call("rbind",lapply(tweetLst,as.data.frame))
	return(twtList1)
}

