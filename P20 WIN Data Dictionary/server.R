## P20 WIN DATA DICTIONARY SERVER SCRIPT ##
# The Server Script contains the instructions for how to build your filters and table (i.e. how they interact and what data to display)
# Shiny Tutorials and other resources: https://shiny.rstudio.com/tutorial/

### Loading Required Packages (install may be required) ####
library(shiny)
library(shinyWidgets)
library(readxl)
library(tidyverse)
library(shinydashboard)
library(shinythemes)
library(bslib)
library(DT)
library(htmlwidgets)
thematic::thematic_shiny(font = "auto")

#### Reading in the Data Dictionary ####
P20WIN_Data_Dictionary <- read_excel("P20WIN_Data_Dictionary.xlsx")

#### Server Script ####
server <- function(session, input, output) {
  
  # The following chunk is helpful when you are testing your app before publishing. If you don't include this your app may not stop running if there are 
  # issues in your script. This function ensures that if you close the app the script will stop running.
  
  #session$onSessionEnded(function() {
  #  stopApp()
  # })
  
  # The following section is taking the input filters created in the ui file and making them reactive to each other. 
  # These filters do need to have a set hierarchy, meaning they should go from most generic to most specific, in this case agency -> program -> data category.
  
  # The first filter event is if the agency filter is used, when this event is observed, the available choices for both the program and data category filters
  # are updated to only display the choices that correspond to the agency/agencies selected. 

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
  
  # The second filter event is if the program filter is used, when this event is observed, the available choices for the data category filter
  # are updated to only display the choices that correspond to the program/programs selected. 
  
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
  
  # It should be noted that filters will not work in the other direction. If you create have a "select agency" filter that updates the program filter then you cannot have
  # a "select program" filter that updates the agency filter because you will end up with a never ending loop where both filters are simultaneously trying to update the other. 
  
  
  # The rest of the script is setting up the data table/data dictionary.
  # The first six lines are naming the input filters as data filters for the table.

  output$mytable <- DT::renderDataTable({
    req(input$select_program)
    req(input$select_category)
    agencies() %>%
      filter(`Data Category` %in% input$select_category) %>%
      filter(Program %in% input$select_program)
    },
    escape = 0,
    options = list(
                scrollX = FALSE, ## disable scrolling on X axis
                scrollY = '64vh',   ## enable scrolling on Y axis and setting table height to 64% of the screens verticle height. This will depend on how tall the navbar or header is.
                autoWidth = FALSE, ## disable auto column widths (set below)
                columnDefs = list(
                  list(targets = c(0), visible = TRUE, width = '60px', ## this column will work as a button to expand the row to show hidden fields (see callback = JS below)
                       orderable = FALSE, className = 'details-control'), 
                  list(targets = c(1,2,3), visible = TRUE, width='89px'), 
                  list(targets = c(4), visible = TRUE, width='215px'), 
                  list(targets = c(5), visible = TRUE), 
                  list(targets = c(6,7), visible = FALSE, width = '0px')), ## hiding the columns that will be shown when the expansion button is clicked
                paging = FALSE,    ## disable paginate so that the table shows as a continuous scroll
                pageLength = 200000, ## number of rows to output for each page. We chose a large number that should not ever be reached to ensure no elements are dropped.
                server = FALSE,   ## use client-side processing
                dom = 'Bfrt',
                buttons = list( ## adding download buttons for CSV and Excel documents. Only the selected elements will be downloaded. 
                  list(extend = 'csv', title = NULL, exportOptions = list(columns = c(1:7)),
                       filename = "P20_WIN_Data_Dictionary"), 
                  list(extend = 'excel', title = NULL, exportOptions = list(columns = c(1:7)),
                        filename = "P20_WIN_Data_Dictionary")
                 )
                ),
    ## custom javascript to create the expansion button and show the hidden child rows. 
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



