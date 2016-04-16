ui <- navbarPage("My App", 
  tabPanel("Slider", 
      sliderInput(inputId = "num", 
        label = "Choose a number", 
        value = 25, min = 1, max = 100)
  ),
  tabPanel("Plot", plotOutput("hist")),
  tabPanel("Summary", verbatimTextOutput("sum"))
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