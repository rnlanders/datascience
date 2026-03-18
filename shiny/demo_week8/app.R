library(shiny)
library(ggplot2)
library(psych)
data(bfi)

ui <- fluidPage(
    titlePanel("Histograms of Agreeableness Items"),
    sidebarLayout(
        sidebarPanel(
            selectInput("selectitem",
                        "Agreeableness item:",
                        choices=paste0("A",1:5))
        ),
        mainPanel(
           plotOutput("histPlot")
        )
    )
)

server <- function(input, output) {

    output$histPlot <- renderPlot({
      ggplot(
        bfi,
        aes(x=!!sym(input$selectitem))) +
        geom_histogram() +
        ylim(c(0,1000))
    })
}

shinyApp(ui = ui, server = server)
