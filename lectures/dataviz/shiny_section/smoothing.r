# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# File Name          : smoothing.r
# Programmer Name    : Luis Campos
#                     lfcampos87@gmail.com
#
# Purpose            : This file contains all the code needed to build a 
#                      smoother Shiny app
#
# Date               : 4/21/2016
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# This file contains all the pieces of the puzzle to create the Kernel
# smoother shiny app:
#  - see finished product at: https://lfcampos.shinyapps.io/Kernel_Smoother/
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #



# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Libraries: not all may be needed, maybe filter these
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
library(dplyr); library(ggplot2); library(broom)
library(stringr); library(lubridate); library(tidyr)
library(XML)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Download the data and clean up
#   Lots of cleanup here, feel free to change whatever you want.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
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



# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# From a drop-down menu you should be able to select one of three options:
#  1. "Box Kernel" = 1 
#  2. "Normal Kernel" = 2
#  3. "Loess Regression" = 3
#  
#  You should also be able to select a Bandwith from a slider
#  
#  bw should be between 1 and 50, as fine precision as you want
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# For the Box Kernel smoother 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
mod <- ksmooth(dat$X, dat$Y, kernel="box", bandwidth = bw)
fit <- data.frame(X=dat$X, .fitted=mod$y)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# For the Normal Kernel smoother 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
mod <- ksmooth(dat$X, dat$Y, kernel="box", bandwidth = bw)
fit <- data.frame(X=dat$X, .fitted=mod$y)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# For Loess Regression Smoother 
# Note: If you look in the help file, you'll see span should be 
#       between 0 and 1, so just divide by the max you chose above 
#       for simplicity
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

mod <- loess(Y~X, degree=2, span = bw/50, data=dat)
fit <- augment(mod)




# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Make figure
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
ggplot(dat, aes(X, Y)) + ylab("(% Obama - % McCain)") + 
 xlab("Days to Election") + geom_point(cex=5) + 
 geom_line(aes(x=X, y=.fitted), data=fit, color="red") + 
 ggtitle('Aggregated Poll Results: 2008 U.S. Presidential')


