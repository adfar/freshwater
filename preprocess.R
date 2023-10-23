library(tidyverse)
library(rvest)
library(janitor)

lakes <- read_html("https://en.wikipedia.org/wiki/List_of_lakes_by_volume") |> 
  html_elements(css = ".wikitable")
lakes <- lakes[[2]] |> 
  html_table() |> 
  clean_names() |> 
  filter(salinity == "Fresh") |> 
  #remove superscript in water_volume for Vostok
  mutate(water_volume = ifelse(name == "Vostok", "5,400 km3 (~1,300 cu mi)", water_volume))



#remove references
lakes$name <- sub("\\[.*\\]", "", lakes$name)

#separate us and metric
lakes <- lakes |> 
  separate(col = surface_area, into = c("km2", "mi2"), sep = "km2") |> 
  separate(col = water_volume, into = c("km3", "mi3"), sep = "km3") |> #vostok has a superscript so km3 doesn't work
  mutate(km2 = gsub("[^0-9]+", "", km2), mi2 = gsub("[^0-9]+", "", mi2), km3 = gsub("[^0-9]+", "", km3), mi3 = gsub("[^0-9]+", "", mi3)) |> 
  mutate(across(all_of(c("km2", "km3", "mi2", "mi3")), as.numeric))

write_csv(lakes, "~/projects/freshwater/data/lakes.csv")



