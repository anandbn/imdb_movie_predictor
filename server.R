#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
options(scipen=999)

library(shiny)
library(caret)
imdb <- read.csv("data/movie_metadata.csv")
imdb<- imdb[complete.cases(imdb),]
imdb_1 <- imdb

imdb_1 <- as.data.frame(lapply(imdb_1,as.numeric))
imdb_1 <- imdb_1[,-nearZeroVar(imdb_1)]

descrCor <-  cor(imdb_1)
imdb_1 <- imdb_1[,-findCorrelation(descrCor)]

inTrain <- createDataPartition(y=imdb_1$gross,p=0.75, list=FALSE)
training <- imdb_1[inTrain,]

modFit <- lm(gross~num_voted_users,data=training)

## Include just complete data for the models to work correctly
imdb <- imdb[complete.cases(imdb),]
imdb$gross_millions <- round(imdb$gross/1000000,1)
# Define server logic required to draw a histogram
shinyServer(
  function(input, output) {
   
    
    getTotalGross <- reactive({
      gross_summs <- colSums(imdb[imdb$title_year >= input$release_year[1] & imdb$title_year <= input$release_year[2],c(9,29)],na.rm = TRUE);
      as.numeric(round(gross_summs[1]/1000000,1))
    })
    
    grossSmry <- reactive({
      gross_smry <- summary(imdb[imdb$title_year >= input$release_year[1] & imdb$title_year <= input$release_year[2],]$gross_millions);
    })
    getDurationSummary <- reactive({
      duration_smry <- summary(imdb[imdb$title_year >= input$release_year[1] & imdb$title_year <= input$release_year[2],]$duration);
    })  
    
    getBoxOfficePrediction <- reactive({
      predict(modFit,newdata = data.frame(num_voted_users=input$user_votes))
    })
    output$total_gross <- renderText(getTotalGross())
    output$min_gross <- renderText(as.numeric(grossSmry()[1]))
    output$max_gross <- renderText(as.numeric(grossSmry()[6]))
    output$min_duration <- renderText(as.numeric(getDurationSummary()[1]))
    output$max_duration <- renderText(as.numeric(getDurationSummary()[6]))
    output$boxOfficePred <- renderText(as.numeric(getBoxOfficePrediction()))
    
    output$distPlot <- renderPlot({
      x <- imdb[imdb$title_year >= input$release_year[1] & imdb$title_year <= input$release_year[2],]
      hist(x$gross_millions,main="Box office Gross",xlab="Gross (millions)")
    
    })
    output$durPlot <- renderPlot({
      
      x <- imdb[imdb$title_year >= input$release_year[1] & imdb$title_year <= input$release_year[2],]
      hist(x$duration,main="Movie Duration",xlab="Duration (mins)")
      
    })
  
})
