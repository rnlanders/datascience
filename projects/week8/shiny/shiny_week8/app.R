library(shiny)
library(ggplot2)
week8shiny_tbl <- readRDS("shiny.RDS")

ui <- fluidPage(

    titlePanel("Week 8 Project"),
    sidebarLayout(
        sidebarPanel(
            selectInput("gender",
                        "Gender:",
                        c("Male","Female","All"),
                        "All"),
            selectInput("errorband",
                        "Error Band:",
                        c("Display Error Band"=TRUE,"Suppress Error Band"=FALSE)),
            selectInput("filterdate",
                        "Exclude Before July 1 2017?",
                        c("Yes","No"))
        ),
        
        mainPanel(
           plotOutput("scatterPlot")
        )
    )
)

server <- function(input, output) {

    output$scatterPlot <- renderPlot({
   
      # AI CHECK   
      if (input$gender == "Male") {
        week8shiny_formatted_tbl <- dplyr::filter(week8shiny_tbl, gender=="Male")
      } else if (input$gender == "Female") {
        week8shiny_formatted_tbl <- dplyr::filter(week8shiny_tbl, gender=="Female")
      } else week8shiny_formatted_tbl <- week8shiny_tbl
      
      if (input$filterdate == "Yes")
        week8shiny_formatted_tbl <- dplyr::filter(week8shiny_formatted_tbl, timefilter == TRUE)

      ggplot(week8shiny_formatted_tbl,
             aes(x=q1q6mean, y=q8q10mean)) +
        geom_point() +
        geom_smooth(method="lm", color="purple", se=as.logical(input$errorband))
    })
}

shinyApp(ui = ui, server = server)
