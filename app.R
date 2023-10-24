library(shiny)
library(tidyverse)
library(DT)

lakes <- read_csv("data/lakes.csv")

ui <- fluidPage(
  titlePanel("Lakes!"),
  fluidRow(
    column(2, 
           selectInput("units", "Units", choices = c("Kilometers", "Miles")),
           selectInput("viz", "Comparison", choices = setNames(c("", "Area", "Volume", "total_volume"), c("", "Area", "Volume", "Region"))),
    ),
    column(5, DTOutput("water")),
    column(5, plotOutput("plot", height = "500px"))
  )
)

server <- function(input, output, session) {
  selected <- reactive(
      if (input$units == "Kilometers") {
        lakes |> 
          select(name, region, km2, km3) |> 
          rename(Name = name, Region = region, Area = km2, Volume = km3)
      } else if (input$units == "Miles") {
        lakes |> 
          select(name, region, mi2, mi3) |> 
          rename(Name = name, Region = region, Area = mi2, Volume = mi3)
    }
  )
  
  grouped <- reactive(
    selected() |> 
      group_by(Region) |> 
      summarize(total_volume = sum(Volume))
  )

  
  output$water <- renderDT({
    selected()
  })
  
  output$plot <- renderPlot({
    req(input$viz)
    if (input$viz == "total_volume") {
      grouped() |> 
        arrange(desc(total_volume)) |> 
        head(10) |> 
        ggplot(aes(!!sym(input$viz), fct_reorder(Region, total_volume))) +
        geom_col(fill = "steelblue") +
        theme_classic() +
        labs(x = "Volume", y = "Region")
    } else {
      selected() |> 
        arrange(!!sym(input$viz)) |> 
        head(10) |> 
        ggplot(aes(!!sym(input$viz), fct_reorder(Name, !!sym(input$viz)))) +
        geom_col(fill = "steelblue") +
        theme_classic() +
        labs(x = input$viz, y = "Name")
    }
  })
  
}

shinyApp(ui, server)