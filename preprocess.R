library(tidyverse)
library(rvest)
library(janitor)

lakes <- read_html("https://en.wikipedia.org/wiki/List_of_lakes_by_volume") |> 
  html_elements(css = ".wikitable")
lakes <- lakes[[2]] |> 
  html_table() |> 
  clean_names() |> 
  filter(salinity == "Fresh")

lakes$name <- sub("\\[.*\\]", "", lakes$name)
lakes <- lakes |> 
  separate(col = surface_area, into = c("km2", "mi2"), sep = " km2 ")


