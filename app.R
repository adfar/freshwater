library(shiny)
library(tidyverse)
library(DT)

lakes <- read_csv("data/lakes.csv")

ui <- fluidPage(
  titlePanel("Lakes!"),
  sidebarLayout(
    sidebarPanel(
      selectInput("units", "Units", choices = c("Kilometers", "Miles"))
    ),
    mainPanel(
      DTOutput("water")
    )
  )
)

server <- function(input, output, session) {
  selected <- reactive(
      if (input$units == "Kilometers") {
        lakes |> 
          select(name, country, region, km2, km3) |> 
          rename(Name = name, Country = country, Region = region, Area = km2, Volume = km3)
      } else if (input$units == "Miles") {
        lakes |> 
          select(name, country, region, mi2, mi3) |> 
          rename(Name = name, Country = country, Region = region, Area = mi2, Volume = mi3)
    }
  )

  
  output$water <- renderDT({
    selected()
  })
  
  output$plot <- renderPlot(
    selected() |> 
      ggplot(aes(Area, Volume)) +
      geom_point()
  )
  
}

shinyApp(ui, server)