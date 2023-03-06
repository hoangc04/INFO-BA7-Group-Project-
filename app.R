library(shiny)
library(tidyverse)
library(plotly)

health <- read.csv("student-mental-health.csv")

ui <- fluidPage(

    titlePanel("BA7 Group Project"),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Overview"),
        
        tabPanel("Plot"),
        
        tabPanel("Table")
        
      )
    )

)


server <- function(input, output) {

}


shinyApp(ui = ui, server = server)
