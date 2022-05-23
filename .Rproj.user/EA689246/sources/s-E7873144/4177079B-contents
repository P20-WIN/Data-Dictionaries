## Loading Necessary Packages
library(shiny)
library(DT)
library(readxl)


P20WIN_Data_Dictionary <- read_excel("~/Metadata Web App/P20WIN_Data_Dictionary.xlsx")

ui <- fluidPage(titlePanel("P20 WIN Data Dictionary"),
                mainPanel(width = 12,
                          DT::dataTableOutput("mytable")))

server <- function(input, output) {
  output$mytable <- DT::renderDataTable(P20WIN_Data_Dictionary,
                                        options = list(paging = TRUE,    ## paginate the output
                                                       pageLength = 940,  ## number of rows to output for each page
                                                       scrollX = TRUE,   ## enable scrolling on X axis
                                                       scrollY = TRUE,   ## enable scrolling on Y axis
                                                       autoWidth = TRUE, ## use smart column width handling
                                                       server = FALSE,   ## use client-side processing
                                                       dom = 'Bfrtip',
                                                       buttons = c('excel')
                                        ),
                                        extensions = 'Buttons',
                                        selection = 'single', ## enable selection of a single row
                                        filter = 'top',              ## include column filters at the bottom
                                        rownames = FALSE                ## don't show row numbers/names
  )
}

# Run the application
shinyApp(ui = ui, server = server)

