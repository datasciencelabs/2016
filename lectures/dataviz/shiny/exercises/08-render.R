library(shiny)

ui <- fluidPage(
  sliderInput("num", "Slide Me", 1, 100, 50),
  plotOutput("hist"),
  verbatimTextOutput("sum")
)
server <- function(input, output) {
   output$hist <- renderPlot({
     hist(rnorm(input$num))   
   })
   output$sum <- renderPrint({
     summary(rnorm(input$num))
   })
}
shinyApp(ui = ui, server = server)