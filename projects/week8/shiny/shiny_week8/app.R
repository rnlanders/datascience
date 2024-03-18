library(shiny)
library(ggplot2)
library(dplyr)

import_tbl <- readRDS("import.RDS")

ui <- fluidPage(
    titlePanel("PSY 8712 Week 8 Shiny Project"),
    sidebarLayout(
        sidebarPanel(
            radioButtons("genderselect",
                         label="Which gender would you like to see?",
                         choices=c("Male","Female","All"),
                         selected="All"),
            radioButtons("errorselect",
                         label="Do you want to see the error bar?",
                         choices=c("Display Error Band"=TRUE,
                                   "Suppress Error Band"=FALSE),
                         selected=TRUE),
            radioButtons("includeselect",
                         label="Do you want to include early participants?",
                         choices=c("Yes",
                                   "No")
                         )
        ),
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    if (input$genderselect == "Male") 
      filtered_tbl <- filter(import_tbl, gender == "M")
    else if (input$genderselect == "Female")
      filtered_tbl <- filter(import_tbl, gender == "F")
    else
      filtered_tbl <- import_tbl
    
    if (input$includeselect == "No") 
      filtered_tbl <- filter(filtered_tbl, afterjuly1 == T)

    ggplot(filtered_tbl,
           aes(x=q1q6mean, y=q8q10mean)) +
      geom_point() +
      geom_smooth(method="lm", 
                  color="purple", 
                  se=as.logical(input$errorselect))
  })
}

shinyApp(ui = ui, server = server)
