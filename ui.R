#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("IMDB Movie Database - Analysis"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("release_year",
                   "Select a release year range",
                   min = 1916,
                   max = 2016,
                   value = c(2000,2016),
                   sep=""),
        h4('Contains 3 analysis panels:'),
        h5(' '),
        h5('Box Office Gross - Box office historgram for the selected release years'),
        h5('Duration - Analysis of movie duration for the selected release years'),
        h5('Predictor - A simple box office gross predictor based on user social media votes'),
        h5(' '),
        h5(' '),
        h5(' '),
        a('Click here for CSV data (source: Kaggle)',href='https://www.kaggle.com/deepmatrix/imdb-5000-movie-dataset/downloads/movie_metadata.csv.zip')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Box Office Gross", 
                 plotOutput("distPlot"),
                 h4('Total Gross (millions)'),
                 verbatimTextOutput("total_gross"),
                 h4('Higest Gross (millions)'),
                 verbatimTextOutput("min_gross"),
                 h4('Lowest Gross (millions) '),
                 verbatimTextOutput("max_gross")
        ),
        tabPanel("Duration",
                 plotOutput("durPlot"),
                 h4('Shortest Movie duration (mins)'),
                 verbatimTextOutput("min_duration"),
                 h4('Longest Movie duration (mins)'),
                 verbatimTextOutput("max_duration")
        ),tabPanel("Box Office Predictor", 
                   sliderInput("user_votes",
                               "Number of User votes",
                               min = 10000,
                               max = 1000000,
                               value = 50000,
                               sep=""),
                   h4("Predicted Box office Gross"),
                   verbatimTextOutput("boxOfficePred")
        )
      )
    )
  )
))
