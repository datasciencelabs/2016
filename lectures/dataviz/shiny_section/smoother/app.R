#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(dplyr)
library(ggplot2)
library(broom)
library(stringr)
library(lubridate)
library(tidyr)
library(XML)
theurl <- paste0("http://www.pollster.com/08USPresGEMvO-2.html")
polls_2008 <- readHTMLTable(theurl,stringsAsFactors=FALSE)[[1]] %>%
  tbl_df() %>% 
  separate(col=Dates, into=c("start_date","end_date"), sep="-",fill="right") %>% 
  mutate(end_date = ifelse(is.na(end_date), start_date, end_date)) %>% 
  separate(start_date, c("smonth", "sday", "syear"), sep = "/",  convert = TRUE, fill = "right")%>% 
  mutate(end_date = ifelse(str_count(end_date, "/") == 1, paste(smonth, end_date, sep = "/"), end_date)) %>% 
  mutate(end_date = mdy(end_date))  %>% mutate(syear = ifelse(is.na(syear), year(end_date), syear + 2000)) %>% 
  unite(start_date, smonth, sday, syear)  %>% 
  mutate(start_date = mdy(start_date)) %>% 
  separate(`N/Pop`, into=c("N","population_type"), sep="\ ", convert=TRUE, fill="left") %>% 
  mutate(Obama = as.numeric(Obama)/100, 
         McCain=as.numeric(McCain)/100,
         diff = Obama - McCain,
         day=as.numeric(start_date - mdy("11/04/2008"))) 

dat <-  filter(polls_2008, start_date>="2008-06-01") %>% 
  group_by(X=day)  %>% 
  summarize(Y=mean(diff))








library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   # Application title
   titlePanel("Kernel Regression Smoother"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        selectInput("select", label = h3("Smoothing Method"), 
                    choices = list("Box Kernel" = 1, "Normal Kernel" = 2, "Loess Regression" = 3), 
                    selected = 1),
        sliderInput("bw",
                     "Bandwidth:",
                     min = 5,
                     max = 50,
                     step =2,
                     value = 25)

      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("plot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   output$plot <- renderPlot({
      # Box Kernel
      if(input$select == 1){
        mod <- ksmooth(dat$X, dat$Y, kernel="box", bandwidth = input$bw)
        fit <- data.frame(X=dat$X, .fitted=mod$y)
      }
     # Normal Kernel
     if(input$select == 2){
       mod <- ksmooth(dat$X, dat$Y, kernel="normal", bandwidth = input$bw)
       fit <- data.frame(X=dat$X, .fitted=mod$y)
      }
     if(input$select == 3){
       mod <- loess(Y~X, degree=1, span = input$bw/50, data=dat)
       fit <- augment(mod)
     }
     
     ggplot(dat, aes(X, Y)) + ylab("(% Obama - % McCain)") + 
       xlab("Days to Election") + geom_point(cex=5) + 
       geom_line(aes(x=X, y=.fitted), data=fit, color="red") + 
       ggtitle('Aggregated Poll Results: 2008 U.S. Presidential')
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

