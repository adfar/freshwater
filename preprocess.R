library(tidyverse)
library(rvest)
library(janitor)

lakes <- read_html("https://en.wikipedia.org/wiki/List_of_lakes_by_volume") |> 
  html_elements(css = ".wikitable")
lakes <- lakes[[2]] |> 
  html_table() |> 
  clean_names() |> 
  filter(salinity == "Fresh")



