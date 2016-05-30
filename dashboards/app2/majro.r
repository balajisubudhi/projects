library(shiny)
runApp(appDir = "D:\\kaggel\\majro\\dashboards\\app2",port = 1009)

library(rsconnect)
rsconnect::setAccountInfo(name='ebsubudhi', token='CB75068AFD1B7E26D2929F0474D888D2', secret='Z2lphVP8XLRH1ldHiQCHePuGZ5F6M+R79SoXIoRh')
deployApp(appDir = "D:\\kaggel\\majro\\dashboards\\app2", appName = "mojro",  account = "ebsubudhi")