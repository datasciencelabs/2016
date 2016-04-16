library(shiny)

ui <- fluidPage(
  sliderInput("num", "Slide Me", 1, 100, 50),
  actionButton("norm", "Normal Data"),
  actionButton("unif", "Uniform Data"),
  plotOutput("hist"),
  verbatimTextOutput("sum")
)

server <- function(input, output) {
   rv <- reactiveValues(data = rnorm(50))
   
   observeEvent(input$norm, {rv$data <- rnorm(input$num)})
   observeEvent(input$unif, {rv$data <- runif(input$num)})
   
   output$hist <- renderPlot({hist(rv$data)})
   output$sum <- renderPrint({summary(rv$data)})
}

shinyApp(ui = ui, server = server)