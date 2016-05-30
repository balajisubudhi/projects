library(shiny)
runApp(appDir = "D:\\github\\dataGeneration1", port = 1009)


library(rsconnect)
deployApp(appDir = "D:\\github\\mojro", appName = "mojro",  account = "ebsubudhi")