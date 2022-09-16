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
P20WIN_Data_Dictionary$`Click to View Additional Information` <- '&oplus;'
P20WIN_Data_Dictionary <- P20WIN_Data_Dictionary[,c(8,1:7)]

server <- function(session, input, output) {
  
  session$onSessionEnded(function() {
    stopApp()
  })
    
  #bs_themer()
  
  agencies <- reactive({
    filter(P20WIN_Data_Dictionary, Agency %in% input$select_agency)
  })
  observeEvent(agencies(), {
    choices_1 <- unique(agencies()$Program)
    choices_2 <- unique(agencies()$`Data Category`)
    updatePickerInput(session,
                      inputId = "select_program",
                      choices=choices_1,
                      selected = choices_1)
    updatePickerInput(session,
                      inputId = "select_category",
                      choices = choices_2,
                      selected = choices_2)
  })
  
  programs <- reactive({
    filter(agencies(), Program %in% input$select_program)
  })
  observeEvent(programs(), {
    choices_3 <- unique(programs()$`Data Category`)
    updatePickerInput(session,
                      inputId = "select_category",
                      choices = choices_3,
                      selected = choices_3)
  })
  

  output$mytable <- DT::renderDataTable({
    req(input$select_program)
    req(input$select_category)
    agencies() %>%
      filter(`Data Category` %in% input$select_category) %>%
      filter(Program %in% input$select_program)
    },
    escape = 0,
    options = list(paging = TRUE,    ## paginate the output
                  pageLength = 2000, ## number of rows to output for each page
                  scrollX = TRUE,   ## enable scrolling on X axis
                  scrollY = TRUE,   ## enable scrolling on Y axis
                  #autoWidth = TRUE,
                  columnDefs = list(
                  #  list(width = '25px', targets = c(0)),
                    list(width = '100px', targets = c(0)),
                    list(width = '200px', targets = c(1,2,3,4)),
                    list(width = '300px', targets = c(5)),
                    list(visible = FALSE, targets = c(6, 7)),
                    list(orderable = FALSE, className = 'details-control', targets = 0)),
                  server = FALSE,   ## use client-side processing
                  dom = 'Bfrtip',
                  buttons = c('csv', 'excel')
                  
    ),
    callback = JS("
  table.column(0).nodes().to$().css({cursor: 'pointer'});
  var format = function(d) {
    return '<div style=\"background-color:#Ffffff; padding: .5em;\"> Data Type: ' +
            d[6] + '<br> Years Available: ' + d[7] + '</div>';
  };
  table.on('click', 'td.details-control', function() {
    var td = $(this), row = table.row(td.closest('tr'));
    if (row.child.isShown()) {
      row.child.hide();
      td.html('&oplus;');
    } else {
      row.child(format(row.data())).show();
      td.html('&CircleMinus;');
    }
  });"
),
    extensions = 'Buttons',
    selection = 'single', ## enable selection of a single row
    #filter = 'top',       ## include column filters at the bottom
    rownames = FALSE      ## don't show row numbers/names
  )
}



