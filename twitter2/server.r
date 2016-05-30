################################################################################
################################################################################
####    server.R                                                            ####
####    this code will take care of all data manipulation                   ####
################################################################################
################################################################################
options(shiny.maxRequestSize=100*1024^8)

cleanTweets = function(tweets)
{
	# remove retweet entities
	tweets = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweets)
	# remove at people
	tweets = gsub("@\\w+", "", tweets)
	# remove punctuation
	tweets = gsub("[[:punct:]]", "", tweets)
	# remove numbers
	tweets = gsub("[[:digit:]]", "", tweets)
	# remove html links
	tweets = gsub("http\\w+", "", tweets)
	# remove unnecessary spaces
	tweets = gsub("[ \t]{2,}", "", tweets)
	tweets = gsub("^\\s+|\\s+$", "", tweets)
	# define "tolower error handling" function 
	try.error = function(x)
	{
		# create missing value
		y = NA
		# tryCatch error
		try_error = tryCatch(tolower(x), error=function(e) e)
		# if not an error
		if (!inherits(try_error, "error"))
		y = tolower(x)
		# result
		return(y)
	}
	# lower case using try.error with sapply 
	tweets = sapply(tweets, try.error)
	# remove NAs in tweets
	tweets = tweets[!is.na(tweets)]	
}

function(input, output) {
	###################################################################################################
	######## code for first dashboard to download twitter data ########################################
	###################################################################################################
	# Fetch data from twitter
	fetchTweet = reactive({
		input$tweet
		# twtList = isolate(searchTwitter(input$entity, n = input$nTweet, cainfo="cacert.pem", lang="en"))
		load("D:\\github\\twitter2\\tweets.RData")
		
		# convert tweet list to data frame
		tweetDF = tweetToDF(twtList)
		return(tweetDF)
	})
	
	#render the info boxs
	output$tweetCount = renderValueBox({
		valueBox(nrow(fetchTweet()), "Tweets Fetched", icon = icon("twitter"), color = "navy")
	})
	output$uniqueTweets = renderValueBox({
		valueBox(length(unique(fetchTweet()$text)), "Unique Tweets", icon = icon("twitter"), color = "navy")
	})
	output$userCount = renderValueBox({
		valueBox(length(unique(fetchTweet()$screenName)), "Unique Users", icon = icon("users"),	color = "navy")
	})
	output$loactionCount = renderValueBox({
		valueBox(length(unique(fetchTweet()$longitude)), "Unique Locations", icon = icon("map-marker"), color = "navy")
	})
	
	#show the raw tweet data in data table
	output$tweetTable = DT::renderDataTable(fetchTweet(),
		rownames = FALSE,
		options = list(scrollX = TRUE)
	)
	
	#function to download the file
    output$downloadData = downloadHandler(
	    filename = function() {paste(input$fileName, '.csv', sep='')},
        content = function(file) {write.csv(fetchTweet(), file, row.names = FALSE)
	})
	###################################################################################################
	######## code for 2nd dashboard to analyse twitter data ###########################################
	###################################################################################################
	#render the info boxs
	output$entityName = renderValueBox({
		valueBox("Entity", input$entity, icon = icon("briefcase"), color = "olive")
	})
	output$tweetCount1 = renderValueBox({
		valueBox(nrow(fetchTweet()), "Tweets Fetched", icon = icon("twitter"), color = "olive")
	})
	output$uniqueTweets1 = renderValueBox({
		valueBox(length(unique(fetchTweet()$text)), "Unique Tweets", icon = icon("twitter"), color = "olive")
	})
	output$retweets = renderValueBox({
		valueBox(sum(fetchTweet()$retweetCount), "Total Retweets", icon = icon("twitter"), color = "olive")
	})
	output$userCount1 = renderValueBox({
		valueBox(length(unique(fetchTweet()$screenName)), "Unique Users", icon = icon("users"),	color = "olive")
	})
	output$loactionCount1 = renderValueBox({
		valueBox(length(unique(fetchTweet()$longitude)), "Unique Locations", icon = icon("map-marker"), color = "olive")
	})
	
	# Sentiment Analysis
	sentimentAnalysis = reactive({
		tweet = fetchTweet()$text
		tweets = cleanTweets(tweet)
		sentiment = 0
		for(i in 1:length(tweets))
		{
			sentiment[i] = polarity(tweets[i])$group$ave.polarity
		}
		return(sentiment)
	})
	
	# plot the sentiment analysis bar chart
	output$sentiBar = renderGvis({
		sentiment = sentimentAnalysis()
		mydata = data.frame(sentiment = c('Neutral', 'Positive', 'Negative'),
							values = c(length(sentiment[sentiment == 0]),
										length(sentiment[sentiment > 0]),
										length(sentiment[sentiment < 0])))
		G1 = gvisPieChart(mydata)
		return(G1)						
	})
	
	# Plot the scatter plot for each sentiment values
	output$sentiScatter = renderGvis({
		sentiment = data.frame(tweetNo = 1:length(sentimentAnalysis()), sentiment = sentimentAnalysis())
		sentiment = sentiment[sample(1:nrow(sentiment), 100),] 
		G2 = gvisScatterChart(sentiment)
		return(G2)						
	})
	
	# Draw a word cloud using the key words
	output$wordCloud = renderPlot({
		tweet_text = fetchTweet()$text
		tweet_corpus = Corpus(VectorSource(tweet_text))
		tdm = TermDocumentMatrix(
		  tweet_corpus,
		  control = list(
			removePunctuation = TRUE,
			removeNumbers = TRUE, tolower = TRUE)
			)
		m = as.matrix(tdm)
		# get word counts in decreasing order
		word_freqs = sort(rowSums(m), decreasing = TRUE) 
		# create a data frame with words and their frequencies
		dm = data.frame(word = names(word_freqs), freq = word_freqs)
		wcloudentity = wordcloud(dm$word, dm$freq, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
		print(wcloudentity)
	})
	
	# Ctreate a table for most negative tweets
	output$extremeTweets = renderGvis({
		tweets = fetchTweet()$text
		sentiment = sentimentAnalysis()
		tweets = data.frame(tweets, sentiment)
		tweets = order(tweets$sentiment)
		names(tweets) = c(Tweet, Sentiment)
		G3 = gvisTable(tweets)
		return(G3)
	})
}
