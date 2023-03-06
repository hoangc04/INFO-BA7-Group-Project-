library(shiny)
library(tidyverse)
library(plotly)

health <- read.csv("student-mental-health.csv")

ui <- fluidPage(

    titlePanel("BA7 Group Project"),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Overview",
                 p("\nThis app describes the results of data collected from a survey conducted to 
                   examine academic variables in comparison to topics of mental health. The 
                   public dataset is titled 'Student Mental Health', and is defined as a 
                   statistical research on the effects of mental health on students' CGPA.\n"),
                 p("\nThis data was collected through a survey catered primarily and solely 
                   to university students. It aims to recognize the correlation or possible 
                   association between academic outcomes and variables of mental heatlh.\n"),
                 p("\nThe following are several samples of observations within the dataset.\n"),
                 tableOutput("sample")),
        
        tabPanel("Plot"),
        
        tabPanel("Table")
        
      )
    )

)


server <- function(input, output) {
  
  output$sample <- renderTable({
    health %>% 
      sample_n(5)
  })
  
}


shinyApp(ui = ui, server = server)
