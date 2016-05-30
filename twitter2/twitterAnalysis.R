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
library("DT")

# A credential obtained from twitter permitting access to their data - A user will need this to proceed
load("D:\\github\\twitter2\\twitter authentication.Rdata") 
registerTwitterOAuth(cred)

#load twitter data
load("D:\\github\\twitter2\\tweets.RData")

#convert tweet list to dataFrame
tweetToDF = function(tweetLst)
{
	twtList1<-do.call("rbind",lapply(tweetLst,as.data.frame))
	return(twtList1)
}

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

tweetDF = tweetToDF(twtList)
cleanTweet = cleanTweets(tweetDF$text)
sentiment = 0
for(i in 1:length(cleanTweet))
{
	sentiment[i] = polarity(cleanTweet[i])$group$ave.polarity
}

mydata = data.frame(sentiment2 = c('Neutral', 'Positive', 'Negative'),
							values = c(length(sentiment[sentiment == 0]),
										length(sentiment[sentiment > 0]),
										length(sentiment[sentiment < 0])))
G1 = gvisColumnChart(mydata, xvar = "sentiment2", yvar = "values")
plot(G1)

tweets.corpus <- Corpus(DataframeSource(data.frame(tweetDF$text)))
tweets.corpus <- tm_map(tweets.corpus, removePunctuation)
tweets.corpus <- tm_map(tweets.corpus, tolower)
tweets.corpus <- tm_map(tweets.corpus, function(x) removeWords(x, stopwords("english")))
tdm <- TermDocumentMatrix(tweets.corpus)
m <- as.matrix(tdm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
pal <- brewer.pal(9, "BuGn")
pal <- pal[-(1:2)]
wordcloud(d$word,d$freq, scale=c(8,.3),min.freq=2,max.words=100, random.order=T, rot.per=.15, colors=pal, vfont=c("sans serif","plain"))
	