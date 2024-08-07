## P20 WIN DATA DICTIONARY USER INTERFACE SCRIPT ##
# The UI Script is used to set up the layout and appearance of your shiny app including pages, widgets, and themes.
# The files necessary should be saved in their own folder with no other files. Your files also cannot call on data from different folders.
# Everything must be contained within the same file directory.
# Shiny Tutorials and other resources: https://shiny.rstudio.com/tutorial/

#### Loading Required Packages (install may be required) ####
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

# Data is initially loaded to build the input filters found below. 
# However, most manipulation of the data should be done in the Server script.

P20WIN_Data_Dictionary <- read_excel("P20WIN_Data_Dictionary.xlsx")

#### UI Script ####
## Setting the page theme ##
# To see more themes available through Bootswatch: https://bootswatch.com/ 
# You can also create a custom theme using a .css file saved in the same file directory as your ui.R and Server.R files.

## Setting the page theme ##
P20_theme <- bs_theme(
  version = version_default(),
  bootswatch = "yeti",
  bg = "#ffffff",
  fg =  "#054266",
  primary = "#00548b",
  secondary = "#0071BB",
  base_font = font_google("Karla"),
  heading_font = font_google("Karla"),
  font_scale = 1.1
)

#capturing the date to include at the bottom of page 
today <- Sys.Date()
today <-format(today, format="%B %d %Y")

## App and Page Layout ##
# If you are including any photos or logos they must be saved within a folder titled "www" within your app's file directory.

shinyUI(
  #our app is currently setup with a navigation bar and multiple pages. If you only need one page, you should use fluidPage instead.
  navbarPage(
    #creating the title that lives on the navbar with our logo and name.
    title = div(img(width = 40, src = "P20WINlogo_color_noname.png", style = "padding-bottom:10px;"),
                "P20 WIN", style = "padding-top:45px; padding-bottom:5px; padding-right:10px;", 
              ), 
    #setting the page theme
    theme = P20_theme,
    #HTML is used here to set the height and padding for the navbar.
    header = tags$style(HTML(' .navbar {
                          height: 60px;
                          min-height:25px !important;
                        }
                      .navbar-nav > li > a, .navbar-brand {
                            padding-top:10px !important; 
                            padding-bottom:25px !important;
                            height: 18px;
                            font-size: 18px;
                            }'),
                        "body {overflow-y: hidden;}"
                        ),
    #These are the pages that will be located in the navbar. We use a regular tabPanel for the first page and then a
    #navbarMenu page with two tabPanel pages nested inside. 
             tabPanel("Data Dictionary",
               #This sidebar panel includes the three filters for agency, program, and category. 
               #They are all multiple selection "pickerInput" filters
               sidebarLayout(
                 sidebarPanel(width = 3,
                              pickerInput("select_agency",
                                          label = "Select Agencies",
                                          choices = as.list(unique(P20WIN_Data_Dictionary$Agency)),
                                          selected = unique(P20WIN_Data_Dictionary$Agency),
                                          options = list(`actions-box` = TRUE,
                                                         `count-selected-text` = "{0}/{1} Selected"),
                                          multiple = TRUE
                                          ),
                              pickerInput("select_program",
                                          label = "Select Programs",
                                          choices = as.list(unique(P20WIN_Data_Dictionary$Program)),
                                          selected = unique(P20WIN_Data_Dictionary$Program),
                                          options = list(`actions-box` = TRUE,
                                                         `count-selected-text` = "{0}/{1} Selected"),
                                          multiple = TRUE
                                          ),
                              pickerInput("select_category",
                                          label = "Select Data Categories",
                                          choices = as.list(unique(P20WIN_Data_Dictionary$`Data Category`)),
                                          selected = unique(P20WIN_Data_Dictionary$`Data Category`),
                                          options = list(`actions-box` = TRUE,
                                                         `count-selected-text` = "{0}/{1} Selected"),
                                          multiple = TRUE
                                          )
                              ),
                 #This panel contains the data dictionary table.
                 mainPanel(
                   width = 9,
                   height = 95,
                   #HTML is used here to hide the horizontal scroll bar
                   tags$table(
                     tags$style(HTML("table {table-layout: fixed;
                                     overflow: hidden;"))
                     ),
                   #we will assign data to "mytable" in the server.R file. 
                   DT::dataTableOutput("mytable"),
                   )
                 ),
               #This row is used to show what date the data dictionary was last updated
               fluidRow(
                 column(8, h6("last updated:", today, align = "left"))
                 )
               ),
            navbarMenu(
              "Data Landscapes",
               tabPanel(
                 "Agencies",
                 fluidPage(title="Agency Data Landscapes",
                           theme = P20_theme
                           ),
                 mainPanel(
                   p("Agency Data Landscapes are currently in development.")
                   )
                 ),
              tabPanel(
                "Topic Areas",
                fluidPage(title="Topic Area Data Landscapes",
                          theme = P20_theme
                          ),
                mainPanel(
                  p("Topic Area Data Landscapes are currently in development.")
                  )
                )
              )
    )
  )

