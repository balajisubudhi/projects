library(shiny)
runApp(appDir = "D:\\github\\DQ",port = 1009)



# hello balaji


cred <- OAuthFactory$new(consumerKey="de4vV4YMqJG8uc02FnbW8oxMy",
      consumerSecret="ff7dQ1debAXmlzvIe0kmBmQb2dE6ssXOwfpRBEcODkT26ZKvHW",
      requestURL="https://api.twitter.com/oauth/request_token",
      accessURL="https://api.twitter.com/oauth/access_token",
      authURL="https://api.twitter.com/oauth/authorize")