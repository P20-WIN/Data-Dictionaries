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
P20WIN_Data_Dictionary$`Click to View More` <- '&oplus;' #adding the column that will be used to expand the selection.
P20WIN_Data_Dictionary <- P20WIN_Data_Dictionary[,c(8,1:7)] #moving the added column to be the first column

#### UI Script ####

#The UI script is used to set the themes, fonts, and layout of the page. 

ui <- fluidPage(title="P20 WIN Data Dictionary",theme = bs_theme(
  bootswatch = "yeti",
  bg = "#ffffff",
  fg = "#054266",
  primary =  "#054266",
  secondary = "#0771BB",
  base_font = font_google("Poppins"),
  heading_font = font_google("Poppins"),
  font_scale = 1
),
titlePanel(
  #This panel contains the title and P20 WIN logo
  fluidRow(
    column(4, h1("P20 WIN Data Dictionary", align = "left",style = "padding-bottom:30px;")),
    column(4, offset = 4, img(width = 175, src = "P20WIN_logo.png", align = "Right", style = "padding-top:30px;"))
    )
  ),
sidebarLayout(
  #This panel includes the three filters for agency, program, and category. They are all multiple 
  #selection "pickerInput" filters 
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
  mainPanel(
    #This panel contains the data dictionary table.
    width = 9,
    tags$head(
      tags$style(HTML("table {table-layout: fixed;"))
      ),
    DT::dataTableOutput("mytable"),
    #tags$hr(style = "border-top: 1px solid #648290;
    #        width: 940px;")
    )
  ),
fluidRow(
  #This row is used to show what date the data dictionary was last updated
  column(8, h6("last updated: 9/22/2022", align = "left"))
)
)

