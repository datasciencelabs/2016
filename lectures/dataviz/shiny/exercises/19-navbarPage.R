library(shiny)

ui <- navbarPage(title = "Random generator",
  tabPanel(title = "Normal data",
    fluidRow(
      column(width = 2,
        actionButton("renorm", "Sample")),
      column(width = 10,
        plotOutput("norm")))),
  tabPanel(title = "Uniform data",
    fluidRow(
      column(width = 2,
        actionButton("reunif", "Sample")),
      column(width = 10,
        plotOutput("unif")))),
  tabPanel(title = "Chi Squared data",
    fluidRow(
      column(width = 2,
        actionButton("rechisq", "Sample")),
      column(width = 10,
        plotOutput("chisq")))))

server <- function(input, output) {
  
  normdata <- eventReactive(input$renorm, {rnorm(100)})
  unifdata <- eventReactive(input$reunif, {runif(100)})
  chisqdata <- eventReactive(input$rechisq, {rchisq(100, df = 2)})
  
  output$norm <- renderPlot({hist(normdata(), breaks = 30, col = "grey", bor = "white")})
  output$unif <- renderPlot({hist(unifdata(), breaks = 30, col = "grey", bor = "white")})
  output$chisq <- renderPlot({hist(chisqdata(), breaks = 30, col = "grey", bor = "white")})
}

shinyApp(server = server, ui = ui)