# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# File Name          : maps.r
# Programmer Name    : Luis Campos
#                     lfcampos87@gmail.com
#
# Purpose            : This file contains all the code needed to build a 
#                      maps Shiny app
#
# Date               : 4/22/2016
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# This was taken straight out of Lesson 5 of the Shiny Tutorial
#  http://shiny.rstudio.com/tutorial/lesson5/
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# You'll need to 
#	1. install maps and mapproj: install.packages(c("maps", "mapproj"))
#	2. Download some pre-cleaned Census Data
#		http://shiny.rstudio.com/tutorial/lesson5/census-app/data/counties.rds
#		Save this to a /data subdirectory
#	3. Download a plotting function they wrote for us so we can 
#	   concetrate on the Shiny app
#		http://shiny.rstudio.com/tutorial/lesson5/census-app/helpers.R
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# percent_map is already written for us: Let's play with it
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
percent_map(counties$white, "darkgreen", "% white")

percent_map(counties$black,  "black", "% Black")

percent_map(counties$hispanic, "darkorange", "% Hispanic")

percent_map(counties$asian, "darkviolet", "% Asian")




# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# Notice that the % Asian Map looks a bit pale, we can adjust the min-max
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
hist(counties$asian)
percent_map(counties$asian, "darkviolet", "% Asian", 0, 10)




# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# So, we esentially have 2 options, 
#	1. a drop-down to select race
#  	2. a slider to select the min-max cutoffs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

