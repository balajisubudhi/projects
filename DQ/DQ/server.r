options(shiny.maxRequestSize=500*1024^2)

shinyServer(function(input, output) {
  
  #This function is repsonsible for loading in the selected file
  filedata <- reactive({
    infile <- input$datafile
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
    }
    unzip(infile$datapath,list=TRUE)
  })
  
  #The following set of functions populate the column selectors
  output$toCol <- renderUI({
    df <-filedata()
    if (is.null(df)) return(NULL)
    items=df[,1]
    names(items)=items
    selectInput("files", "Select Files to Check:",items,multiple=FALSE)
  })
  
  #This previews the list of CSV data file
  output$filetable <- renderGvis({
    mydata=filedata()
	mydata$Date=as.character(as.POSIXct(mydata$Date, origin="1970-01-01"))
	names(mydata)=c("Name","Size","Last Modified")
	
	# read all the file for overall DQ
	infile = input$datafile
	files=mydata$Name
	Name=0
	No_of_Rows=0
	Type=0
	Unique_Rows=0
	Missing_Rows=0
	FileName=0
	j=1
	for(i in 1:length(files))
	{
		data1= read.csv(unz(infile$datapath,files[i]),header=T,sep=",")
		for(k in 1:length(names(data1)))
		{
			Name[j]=names(data1)[k]
			No_of_Rows[j]=nrow(data1)
			Type[j]=class(data1[,k])
			Unique_Rows[j]=length(unique(data1[,k]))
			Missing_Rows[j]=length(subset(data1[,k],is.na(data1[,k])==TRUE))
			FileName[j]=files[i]
			j=j+1
		}
	}
	data_quality=data.frame(FileName,Name,No_of_Rows,Type,Unique_Rows,Missing_Rows)
	filename=0
	NC=0
	NR=0
	MR=0
	Quality=0
	modified=0
	size=0
	for(i in 1:nrow(mydata))
	{
		filename[i]=mydata[i,"Name"]
		NC[i]=nrow(subset(data_quality,data_quality$FileName==mydata[i,"Name"]))
		NR[i]=subset(data_quality,data_quality$FileName==mydata[i,"Name"])[1,"No_of_Rows"]
		MR[i]=sum(subset(data_quality,data_quality$FileName==mydata[i,"Name"])[,"Missing_Rows"])
		Quality[i]=round(100-((MR[i]*100)/(NC[i]*NR[i])),2)
		modified[i]=mydata[i,"Last Modified"]
		size[i]=mydata$Size[i]
	}
	DQ_Table=data.frame(filename,size,NC,NR,MR,Quality,modified)
	DQ_TABLE=data.frame(filename,size,NC,NR,MR,Quality,modified)
	names(DQ_TABLE)=c("File Name","Size","No Of Columns","No of Rows","No of Missing Rows","Quality in %","Last Modified")
	
	t1=gvisTable(DQ_TABLE,options=list(page="enable",width=800,length=800))
	
	type=c("Numeric","Character","Date")
	count=0
	count[1]=nrow(subset(data_quality,data_quality$Type=="numeric" | data_quality$Type=="integer"))
	count[2]=nrow(subset(data_quality,data_quality$Type=="factor" ))
	count[3]=0
	Type=data.frame(type,count)
	t2=gvisPieChart(Type,options=list(width=250,length=400))
	t3=gvisColumnChart(DQ_Table, xvar="filename", yvar="Quality",options=list(width=400,length=400))	
	quality=round(mean(DQ_Table$Quality),2)
	name="Quality"
	Quality=data.frame(name,quality)
	t4=gvisGauge(Quality,options=list(min=0, max=100, greenFrom=80,greenTo=100, yellowFrom=40, yellowTo=80,redFrom=0, redTo=40, width=150,length=300))
	
	t2t3=gvisMerge(t2,t3,horizontal=TRUE)
	t2t3t4=gvisMerge(t2t3,t4,horizontal=TRUE)
	t1t2t3t4=gvisMerge(t1,t2t3t4,horizontal=FALSE) 
	return(t1t2t3t4)
  })
  
  #This function load the file into memory after it got selected 
  fileselect <- reactive({
	infile = input$datafile
	filelist=filedata()[,1]
	files = subset(filelist, filelist==input$files)
	data1= read.csv(unz(infile$datapath,files),header=T,sep=",")
	data1
	})
  
  #This previews description of selected CSV file
  output$filetable1 <- renderGvis({
	x=fileselect()
	filelist=filedata()[,1]
	Name=0
	No_of_Rows=0
	Type=0
	Unique_Rows=0
	Missing_Rows=0
	Min=0
	Mean=0
	Median=0
	Max=0
	FileName=0
	for(i in 1:length(x[1,]))
	{
		No_of_Rows[i]=as.character(length(x[,i]),0)
		Type[i]=class(x[,i])
		Unique_Rows[i]=as.character(length(unique(x[,i])))
		Missing_Rows[i]=as.character(length(subset(x[,i],is.na(x[,i])==TRUE)))
		FileName[i]=subset(filelist, filelist==input$files)
		if(Type[i] == "character" || Type[i] == "logical" || Type[i] == "factor")
		{
			Min[i]=as.character(0)
			Mean[i]=as.character(0)
			Median[i]=as.character(0)
			Max[i]=as.character(0)
		}else
		{
			Min[i]=as.character(min(x[,i][is.na(x[,i])==FALSE]))
			Mean[i]=as.character(round(mean(x[,i][is.na(x[,i])==FALSE]),2))
			Median[i]=as.character(round(median(x[,i][is.na(x[,i])==FALSE]),2))
			Max[i]=as.character(max(x[,i][is.na(x[,i])==FALSE]))
		}
	}
	Name=names(x)
	datadiscription=data.frame(FileName,Name,No_of_Rows,Type,Unique_Rows,Missing_Rows,Min,Mean,Median,Max)
	t1 <- gvisTable(datadiscription)
	return(t1)
  })
  
})