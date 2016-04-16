library(shiny)

ui <- fluidPage(
  sliderInput("num", "Choose a number:", 1, 100, 50),
  plotOutput("hist")
)

server <- function(input, output) {
  output$hist <- renderPlot({
     hist(rnorm(input$num))
  })
}

shinyApp(ui = ui, server = server)