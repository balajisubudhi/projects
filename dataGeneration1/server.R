################################################################################
################################################################################
####    server.R                                                            ####
####    this code will take care of all data manupulation                   ####
################################################################################
################################################################################
options(shiny.maxRequestSize=100*1024^8)

randDayTime = function(dayStart, dayEnd, hourStart, hourEnd, size){
  daySeq = seq.Date(as.Date(dayStart),as.Date(dayEnd),by="day")
  daySelect = sample(daySeq,size,replace=TRUE)
  hourSelect = sample(hourStart:hourEnd,size,replace=TRUE)
  minSelect = sample(0:59,size,replace=TRUE)
  secSelect = sample(0:59,size,replace=TRUE)
  as.POSIXlt(paste(daySelect, " ", hourSelect, 
                                ":", minSelect, ":", secSelect, sep=""))
}

newDataFrame = data.frame(0)

function(input, output) {
  #create the dataset
    createDataFrame = reactive({
		validate(
			need(input$noRows != "", "Please enter no of rows and generate a column")
		)
        if(input$datatype == "numeric"){
          if(input$distribution == "normal"){
            dataFrame = data.frame(rnorm(input$noRows, 
                            mean = input$normalmean, sd = input$normalsd))
          }
          else if(input$distribution == "uniform"){
            dataFrame = data.frame(runif(input$noRows, 
                        min = input$uniformmin, max = input$uniformmax))
          }
          else if(input$distribution == "triangular"){
            dataFrame = data.frame(rtriangle(input$noRows, 
                    input$triangularmin, input$triangularmax))
          }
          else if(input$distribution == "exponential"){
            dataFrame = data.frame(rexp(input$noRows, rate = input$exponentialrate))
          }
          else if(input$distribution == "random"){
            dataFrame = data.frame(sample(input$randommin:input$randommax, 
                                    input$noRows, replace = TRUE))
          }
          else if(input$distribution == "sequential"){
            dataFrame = data.frame(input$sequentialmin:
                                    (input$sequentialmin+input$noRows-1))
          }
        }
        else if(input$datatype == "character"){
          if(input$characterType == "fName"){
            dataFrame = data.frame(firstNames[sample(1:nrow(firstNames), input$noRows, replace = TRUE ),])
          }
		  else if(input$characterType == "lName"){
            dataFrame = data.frame(lastNames[sample(1:nrow(lastNames), input$noRows, replace = TRUE ),])
          }
		  else if(input$characterType == "place"){
            dataFrame = data.frame(places[sample(1:nrow(places), input$noRows, replace = TRUE ),])
          }
		  else if(input$characterType == "factor"){
            factorValues = data.frame(strsplit(input$factors, ','))
			dataFrame = data.frame(factorValues[sample(1:nrow(factorValues), input$noRows, replace = TRUE ),])
          }
        }
        else if(input$datatype == "date"){
          if(input$dateType == "oDate"){
            noOfDays = input$eDate - input$sDate
            dataFrame = data.frame(input$sDate + sample(0:noOfDays, 
                                            input$noRows, replace = TRUE))
          }
          else if(input$dateType == "dateTime"){ 
            dataFrame = data.frame(randDayTime(input$sDate, input$eDate,
                                       input$sHour, input$eHour, input$noRows)) 
          }
          else if(input$dateType == "timeStamp"){ 
            dataFrame = randDayTime(input$sDate, input$eDate,
                                       input$sHour, input$eHour, input$noRows)
            dataFrame = data.frame(as.numeric(as.POSIXct(dataFrame)))
          }
        }
        names(dataFrame) = input$colName
        return(dataFrame)
    })
    finalDataFrame = reactive({
        input$goButton
		dataFrame = isolate(createDataFrame())
		name = names(newDataFrame)
		name = gsub('[[:digit:]]+', '', name)
		newName = names(dataFrame)
		occurance = length(subset(name, name == newName))
		if(occurance > 0)
		{
			names(dataFrame) = paste(newName, occurance, sep = "")
		}
		if(nrow(newDataFrame) == 1 && ncol(newDataFrame) == 1){
			newDataFrame <<- dataFrame
		}else
		{
			newDataFrame <<- cbind(newDataFrame, dataFrame)
		}
		newDataFrame
	})
	deleteDataFrame = reactive({
		if(input$delete){
			if(ncol(newDataFrame) <= 2)
			{isolate(newDataFrame <<- data.frame(0))}
			else {isolate(newDataFrame <<- newDataFrame[,!names(newDataFrame) %in% input$delCol])}
		}
	})
	finalDataFrame1 = reactive({
		finalDataFrame()
		deleteDataFrame()
		newDataFrame	
	})
    output$opTable = DT::renderDataTable(finalDataFrame1(),
		rownames = FALSE,
		options = list(scrollX = TRUE)
	)
    #function to download the file
    output$downloadData = downloadHandler(
	    filename = function() {paste(input$fileName, '.csv', sep='')},
        content = function(file) {write.csv(finalDataFrame(), file, row.names = FALSE)
	})
	
	#function to render the drop down for delete
	output$toCol <- renderUI({
		df <-finalDataFrame1()
		if (is.null(df)) return(NULL)
		items=names(df)
		names(items)=items
		selectInput("delCol", "Select Column to Delete:", items, selected = "", multiple=FALSE)
	})
	#function to render the visualization 
	output$viz <- renderGvis({
		dataFrame = createDataFrame()
		if(input$datatype == "numeric"){
			histogram = gvisHistogram(dataFrame, option=list(title = names(dataFrame), height = 115))
			return(histogram)
		}
		else if(input$datatype == "character")
		{
			myData = data.frame(table(dataFrame))
			myData1 =  data.frame(myData$Freq)
			tbl = gvisHistogram(myData1, option=list(title = names(dataFrame), height = 115))
			return(tbl)
		}
		else if(input$datatype == "date")
		{
			myData = data.frame(table(dataFrame))
			myData1 =  data.frame(myData$Freq)
			tbl2 = gvisHistogram(myData1, option=list(title = names(dataFrame), height = 115))
			return(tbl2)
		}
	})
}