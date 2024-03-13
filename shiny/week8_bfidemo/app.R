library(shiny)
library(tidyverse)
library(psych)
bfi_tbl <- readRDS("bfi.RDS")

ui <- fluidPage(

    titlePanel("App to Look at Agreeableness Items"),

    sidebarLayout(
        sidebarPanel(
            radioButtons("itemchoice",
                        "Which item do you want?",
                        choices = c("A1","A2","A3","A4","A5"))
        ),

        mainPanel(
           plotOutput("bfiplot")
        )
    )
)

server <- function(input, output) {

    output$bfiplot <- renderPlot({
      # sliced_tbl <- select(bfi_tbl, myA = input$itemchoice)
      ggplot(bfi_tbl, aes(x=!!sym(input$itemchoice))) + geom_histogram()
    })
}

shinyApp(ui = ui, server = server)
