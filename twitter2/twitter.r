library(shiny)
runApp(appDir = "D:\\github\\twitter2",port = 1009)

library(rsconnect)
rsconnect::setAccountInfo(name='balajisubudhi', token='C6E36D1203ADC8499F8BCD33404DEAEC', secret='dLro3oHEYDGA1d7LxY+iesUuYflk2qjQ3k+wEnmf')
deployApp(appDir = "D:\\github\\Twitter", appName = "Twitter")

showLogs(appDir =  "C:\\Users\\balaji.subudhi\\Desktop\\twitter", appName = "Twitter", account = "balajisubudhi", entries = 50,streaming = TRUE)