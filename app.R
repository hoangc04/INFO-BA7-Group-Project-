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
                 imageOutput("img"),
                 tags$blockquote("Data set: 'Student Mental Health' created by MD Shariful Islam; 
                                 extracted from Kaggle."),
                 hr(),
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
        
        tabPanel("Variables",
                 headerPanel("Sample Observations"),
                 p("Use the slider to observe samples of observations from the data set."),
                 sidebarLayout(
                   sidebarPanel(
                     sliderInput("n", "Number of Observations:",
                                 min = 5,
                                 max = 100,
                                 value = 10),
                     p("\nThis data set includes 10 recorded variables. All responses and 
                       observations from participants include the following variables: gender, 
                       age, course, current year of study, CGPA, marital status, and answers to 
                       mental heatlh focused topics including depression, anxiety, panic attacks, 
                       and treatment.")
                   ),
                   mainPanel(
                     tableOutput("table1")
                   )
                 )),
        
        tabPanel("Filtered Observations",
                 sidebarLayout(
                   sidebarPanel(
                     tabsetPanel(
                       tabPanel("Gender",
                                selectInput(inputId = "gender", label = "Choose your gender:",
                                            choices = c("Female", "Male"), selected = "Female")),
                       tabPanel("Anxiety and Year of Study",
                                selectInput(inputId = "anxiety", label = "Do you have Anxiety?",
                                            choices = c("Yes", "No")),
                                selectInput(inputId = "year", label = "What is your current year of study?",
                                            choices = c("Year 1", "Year 2", "Year 3", "Year 4", "Year 5+"),
                                            selected = "Year 1")),
                       tabPanel("Treatment",
                                selectInput(inputId = "treatment", label = "Did you seek any specialist for treatment?",
                                            choices = c("Yes", "No")))
                     )
                   ),
                   mainPanel(
                     tabsetPanel(
                       tabPanel("Data", tableOutput(outputId = "table")),
                       tabPanel("Summary", verbatimTextOutput(outputId = "summary"))
                     )
                   )
                 )),
        
        tabPanel("Page #3"),
        
        tabPanel("Conclusion")
        
      )
    )

)


server <- function(input, output) {
  
  output$table1 <- renderTable({
    health %>% 
      sample_n(input$n)
  })
  
  output$img <- renderImage({
    list(src = "imgs/dataset-cover.jpg",
         width = "100%",
         height = 250)
  }, deleteFile = F)
  
  subset_data <- reactive({
    data_subset <- health
    
    if (!is.null(input$gender) & input$gender != "All") {
      data_subset <- subset(data_subset, Choose.your.gender == input$gender)
    }
    
    if (!is.null(input$anxiety) & input$anxiety != "All") {
      data_subset <- subset(data_subset, Do.you.have.Anxiety. == input$anxiety)
    }
    
    if (!is.null(input$year) & input$year != "All") {
      data_subset <- subset(data_subset, Your.current.year.of.Study == input$year)
    }
    
    if (!is.null(input$treatment) & input$treatment != "All") {
      data_subset <- subset(data_subset, Did.you.seek.any.specialist.for.a.treatment. == input$treatment)
    }
    
    return(data_subset)
  })
  
  output$table <- renderTable({
    subset_data()
  })
  
  output$summary <- renderPrint({
    summary(subset_data())
  })
  
}


shinyApp(ui = ui, server = server)
