library(shiny)
library(shinyWidgets)
library(readxl)
library(tidyverse)
library(shinydashboard)
library(shinythemes)

P20WIN_Data_Dictionary <- read_excel("P20WIN_Data_Dictionary.xlsx")

ui <- fluidPage(theme = shinytheme("cerulean"),
  headerPanel(
    fluidRow( 
      column(4, h1("P20 WIN Data Dictionary", align = "left")),
      column(4, offset = 4, img(height = 50, src = "P20WIN_logo.png", align = "Right"))
      )
    ),
  sidebarLayout(
    sidebarPanel(width = 3, 
                 tags$head(tags$style("#mytable{height:100vh !important;}")
                           ),
      pickerInput("select_source",
                  label = "Select Sources",
                  choices = unique(P20WIN_Data_Dictionary$Source),
                  selected = unique(P20WIN_Data_Dictionary$Source),
                  options = list(`actions-box` = TRUE,
                                `count-selected-text` = "{0}/{1} Selected"),
                  multiple = TRUE),
      pickerInput("select_category",
                  "Select Data Categories",
                  choices = as.list(unique(P20WIN_Data_Dictionary$`Data Category`)),
                  selected = unique(P20WIN_Data_Dictionary$`Data Category`),
                  options = list(`actions-box` = TRUE,
                                `count-selected-text` = "{0}/{1} Selected"),
                 multiple = TRUE)
      ),
    mainPanel(width = 9,
      DT::dataTableOutput("mytable"),
      )
    ))

