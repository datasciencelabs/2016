library(shiny)

ui <- fluidPage(
  sliderInput("num", "Choose a number:", 1, 100, 50)  
)

server <- function(input, output) {}

shinyApp(ui = ui, server = server)