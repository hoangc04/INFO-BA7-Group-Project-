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
                    relevant to our analysis and will be addressing. Variables will include demographics,
                     academic situation, and several mental health topics. These observations were 
                     collected in 2020, conducted as an online survey primarily and solely catered
                     towards university students.\n"),
                 headerPanel("Purpose"),
                 p("\nThe purpose of examining this data set is to find an association between academic 
                   situation and state of mental health. As the data has been collected from 
                   university students, they will be our main audience to address. However, the findings 
                   from this report can also apply to other audiences in similar academic situations.\n"),
                 headerPanel("Contributors"),
                 p("Cassie Hoang, Daniel Villasenor, Xiangguang Zhou, Denali Lindeke")),
        
        tabPanel("Variables",
                 p("Choose which variables to display to compare observations."),
                 sidebarLayout(
                   sidebarPanel(
                     checkboxGroupInput("variables", "Select variables to display:",
                                        choices = colnames(health), selected = "What.is.your.CGPA."),
                     hr(),
                     p("\nThis data set includes 10 recorded variables. All responses and 
                       observations from participants include the following variables: gender, 
                       age, course, current year of study, CGPA, marital status, and answers to 
                       mental heatlh focused topics including depression, anxiety, panic attacks, 
                       and treatment.")
                   ),
                   mainPanel(
                     tableOutput(outputId = "checktable")
                   )
                 )),
        
        tabPanel("Filtered Observations",
                 sidebarLayout(
                   sidebarPanel(p("Use the following functions to filter observations based on specified answers. 
                                  This page focuses on addressing anxiety as a general statement of mental health."), 
                                hr(),
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
        
        tabPanel("CGPA & Anxiety",
                 plotlyOutput("plot"),
                 hr(),br(),
                 p("The stacked bar graph measures the amount of observations that have answered 
                   'Yes' or 'No' to having anxiety as a measure of mental health and 
                   their current CGPA. Few observations lie in the lower values of CGPA, but 
                   the ones that do appear contain observations with 'No' answered for anxiety."),
                 br(),
                 p("The majority of observations, regardless of how they answered to 
                   the question about anxiety, lie in CGPA values of 3.00-3.50 or 3.50-4.00. 
                   Within these two bars, it is observed that the count of observation that have 
                   answered 'Yes' to having anxiety total more than those that have answered 'No'.")),
        
        tabPanel("Conclusion",
                 br(),
                 p("We have decided to base the results of our study on the relations between variables, 
                   and more specifically, the associations between certain demographics and mental health. 
                   In the observations that we examined, we focused on gender, current year of study, anxiety, 
                   and treatment. Anxiety was our primary focus to generalize mental health among the 
                   participants."),
                 br(),
                 p("Our conclusions primarily draw from the stacked bar graph constructed. 
                   It measures the count of observations based on answers to anxiety and CGPA. 
                   The graph shows that a higher population of students who have higher CGPAs have 
                   anxiety. This suggests that having anxiety, or in general poor mental health, 
                   is associated with a higher CGPA or academic situation. By this conclusion, we 
                   assume that university students have poor mental health as a result of the 
                   efforts of their successful academic situations."),
                 br(),
                 p("When working with the data set, we found our data of reasonable quality. 
                   The data was generated from a conducted survey, and results were produced 
                   reasonably. The data set is not large, and only contains around 100 observations, 
                   but we still felt that the observations were sufficient enough to lead us to our 
                   conclusion."),
                 br(),
                 p("In response to our result, the solution that we provide for this problem is 
                   for university students to better manage their time between academics and 
                   self-care. By balancing personal life with education, success will not 
                   come at the expense of their own well-being. By doing so, we predict that 
                   anxiety levels will decrease, and a better relationship between academic 
                   situation and mental health will occur."))
        
      )
    )

)


server <- function(input, output) {

  output$checktable <- renderTable({
    health[, unlist(input$variables), drop = FALSE]
  })
  
  output$img <- renderImage({
    list(src = "imgs/dataset-cover.jpg",
         width = "75%",
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
  
  output$plot <- renderPlotly({
    health %>% 
      group_by(What.is.your.CGPA.) %>% 
      ggplot(aes(x = What.is.your.CGPA., y = Do.you.have.Anxiety., fill = factor(Do.you.have.Anxiety.))) +
      geom_col() +
      labs(title = "CGPA based on Anxiety for University Students",
           x = "Current Grade Point Average (CGPA)",
           y = "Count",
           fill = "Anxiety?")
  })
  
}


shinyApp(ui = ui, server = server)
