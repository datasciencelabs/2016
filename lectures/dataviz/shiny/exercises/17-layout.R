ui <- fluidPage(
  fluidRow(
    column(3, 
      sliderInput("num", "Choose a number", 1, 100, 50)
    ),
    column(9, 
      plotOutput("hist")
    )
  ),
  fluidRow(
    column(5, offset = 5,
      verbatimTextOutput("sum")
    )
  )
)

server <- function(input, output) {
  data <- reactive({rnorm(input$num)})
  output$hist <- renderPlot({
    hist(data())   
  })
  output$sum <- renderPrint({
    summary(data())
  })
}

shinyApp(ui = ui, server = server)