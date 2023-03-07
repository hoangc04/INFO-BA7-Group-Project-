library(shiny)
library(tidyverse)
library(plotly)

health <- read.csv("student-mental-health.csv")

ui <- fluidPage(

    titlePanel("Student Mental Health"),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Overview",
                 headerPanel("General Overview"),
                 p("\nThis app describes the results of data collected from a survey conducted to 
                   examine academic variables in comparison to topics of mental health. The 
                   public dataset is titled 'Student Mental Health', and is defined as a 
                   statistical research on the effects of mental health on students' CGPA.\n"),
                 headerPanel("Data"),
                 p("\nAs explained, we are working with a public data set published on Kaggle. 
                   data set contains 101 observations, and 11 variables, 9 variables of which are
                    relevant to out analysis and will be addressing. Variables will include demographics,
                     academic situation, and several mental health topics. These observations were 
                     collected in 2020, conducted as an online survey primarily and solely catered
                     towards university students.\n"),
                 headerPanel("Purpose"),
                 p("\nThe purpose of examining this data set is to find an association between academic 
                   situation and state of mental health. As the data has been collected from 
                   university students, they will be our main audience to address. However, the findings 
                   from this report can also apply to other audiences in current academic situations.\n")),
        
        tabPanel("Page #1",
                 headerPanel("Sample Observations"),
                 p("Use the slider to observe samples of observations from the data set."),
                 sidebarLayout(
                   sidebarPanel(
                     sliderInput("n", "Number of Observations:",
                                 min = 5,
                                 max = 100,
                                 value = 10)
                   ),
                   mainPanel(
                     tableOutput("table1")
                   )
                 )),
        
        tabPanel("Page #2"),
        
        tabPanel("Page #3")
        
      )
    )

)


server <- function(input, output) {
  
  output$table1 <- renderTable({
    health %>% 
      sample_n(input$n)
  })
  
}


shinyApp(ui = ui, server = server)
