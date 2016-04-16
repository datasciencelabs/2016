library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel( 
      sliderInput("num", "Choose a number", 1, 100, 50),
      tags$img(height = 120, src = "shiny.png"),
      tags$br(),
      tags$em("Powered by "),
      tags$a(href = "shiny.rstudio.com", "shiny")
    ),
    mainPanel( 
      plotOutput("hist"),
      verbatimTextOutput("sum")
    )
  )
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