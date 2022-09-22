#### Installing Packages ####
library(shiny)
library(shinyWidgets)
library(readxl)
library(tidyverse)
library(shinydashboard)
library(shinythemes)
library(bslib)
library(DT)
thematic::thematic_shiny(font = "auto")

#### Reading in the Data Dictionary ####
P20WIN_Data_Dictionary <- read_excel("P20WIN_Data_Dictionary.xlsx")
P20WIN_Data_Dictionary$`Click to View Additional Information` <- '&oplus;' #adding the column that will be used to expand the selection.
P20WIN_Data_Dictionary <- P20WIN_Data_Dictionary[,c(8,1:7)] #moving the added column to be the first column

#### Server Script ####
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
    options = list(                
                scrollX = TRUE,   ## enable scrolling on X axis
                scrollY = 400,   ## enable scrolling on Y axis
                autoWidth = TRUE,
                columnDefs = list(
                  list(targets = c(0), visible = TRUE, width = '90px',
                       orderable = FALSE, className = 'details-control'), 
                  list(targets = c(1,2,3,4), visible = TRUE, width='100px'), 
                  list(targets = c(5), visible = TRUE, width='430px'), 
                  list(targets = c(6,7), visible = FALSE, width = '0px')), 
                paging = FALSE,    ## paginate the output
                pageLength = 2000, ## number of rows to output for each page
                server = FALSE,   ## use client-side processing
                dom = 'Bfrt',
                buttons = list(
                  list(extend = 'csv', title = NULL, exportOptions = list(columns = c(1:7)),
                       filename = "P20_WIN_Data_Dictionary"), 
                  list(extend = 'excel', title = NULL, exportOptions = list(columns = c(1:7)),
                        filename = "P20_WIN_Data_Dictionary")
                 )
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
    rownames = FALSE      ## don't show row numbers/names
  )
}



