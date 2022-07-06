library(shiny)
library(shinyWidgets)
library(readxl)
library(tidyverse)
library(shinydashboard)
library(shinythemes)
library(bslib)
library(DT)

thematic::thematic_shiny(font = "auto")

P20WIN_Data_Dictionary <- read_excel("P20WIN_Data_Dictionary.xlsx")


server <- function(session, input, output) {
    
  #bs_themer()
  
  sources <- reactive({
    filter(P20WIN_Data_Dictionary, Source %in% input$select_source)
  })
  observeEvent(sources(), {
    choices <- unique(sources()$`Data Category`)
    updatePickerInput(session,
                      inputId = "select_category",
                      choices=choices,
                      selected = choices)
  })

  output$mytable <- DT::renderDataTable({
    req(input$select_category)
    sources() %>%
      filter(`Data Category` %in% input$select_category),
    P20WIN_Data_Dictionary <- P20WIN_Data_Dictionary[input$range[1]:input$range[2],]
    },
    options = list(paging = TRUE,    ## paginate the output
                  pageLength = 100000, ## number of rows to output for each page
                  scrollX = TRUE,   ## enable scrolling on X axis
                  scrollY = TRUE,   ## enable scrolling on Y axis
                  columnDefs = list(
                    list(width = '200px', targets = "_all")),
                  server = FALSE,   ## use client-side processing
                  dom = 'Bfrtip',
                  buttons = c('csv', 'excel')
                  
    ),
    extensions = 'Buttons',
    selection = 'single', ## enable selection of a single row
    #filter = 'top',       ## include column filters at the bottom
    rownames = FALSE      ## don't show row numbers/names
  )
}




