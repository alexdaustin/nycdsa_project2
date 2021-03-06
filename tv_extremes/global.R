library(shiny)
library(bslib)
library(thematic)
library(readr)
library(dplyr)
library(ggplot2)
library(extRemes)
library(stringr)
library(lubridate)
library(pastecs)

thematic_shiny(font = "auto")

ts_shows <- read_csv("ts_shows.csv")

show_names <- c("The Big Bang Theory", "NCIS", "CIS", 
                "Desperate Housewives", "Friends", "ER", "Frasier", 
                "Seinfeld", "Home Improvement", "Roseanne", "Cheers")

sitcom_names <- c("The Big Bang Theory", "Friends", "Frasier", 
                  "Seinfeld", "Home Improvement", "Roseanne", "Cheers")

drama_names <- c("NCIS", "CIS", "ER")

show_select <- function(input) {
  if (input=="All"){
    shows=show_names
  } else if (input == "Sitcoms") {
    shows=sitcom_names
  } else if (input == "Dramas") {
    shows=drama_names
  } else {shows=input}
  return(shows)
}

ext_data <- function(shows, num) {
  block_max = ts_shows %>%
    filter(show %in% shows) %>%
    filter(!is.na(.data[[paste0("return_", num)]])) %>%
    group_by(tv_year) %>%
    summarise(seas_max=max(.data[[paste0("return_", num)]]))
  
  return(data.frame(block_max))
}



