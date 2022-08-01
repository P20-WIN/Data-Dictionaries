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
    fluidRow( 
      column(4, h1("P20 WIN Data Dictionary", align = "left",style = "padding-bottom:30px;")),
      column(4, offset = 4, img(width = 175, src = "P20WIN_logo.png", align = "Right", style = "padding-top:30px;"))
      )
    ),
  sidebarLayout(
    sidebarPanel(width = 3,
                 pickerInput("select_agency",
                             label = "Select Agencies",
                             choices = unique(P20WIN_Data_Dictionary$Agency),
                             selected = unique(P20WIN_Data_Dictionary$Agency),
                             options = list(`actions-box` = TRUE,
                                            `count-selected-text` = "{0}/{1} Selected"),
                             multiple = TRUE
                             ),
                 pickerInput("select_program",
                             "Select Programs",
                             choices = as.list(unique(P20WIN_Data_Dictionary$Program)),
                             selected = unique(P20WIN_Data_Dictionary$Program),
                             options = list(`actions-box` = TRUE,
                                            `count-selected-text` = "{0}/{1} Selected"),
                             multiple = TRUE
                             ),
                 pickerInput("select_category",
                             "Select Data Categories",
                             choices = as.list(unique(P20WIN_Data_Dictionary$`Data Category`)),
                             selected = unique(P20WIN_Data_Dictionary$`Data Category`),
                             options = list(`actions-box` = TRUE,
                                            `count-selected-text` = "{0}/{1} Selected"),
                             multiple = TRUE
                             )
            #     pickerInput("select_years",
            #                        "Filter Elements by Years Available:",
            #                        choices = as.list(unique(P20WIN_Data_Dictionary$`Years Available`)),
            #                        selected = unique(P20WIN_Data_Dictionary$`Years Available`),
            #                 options = list(`actions-box` = TRUE,
            #                                `count-selected-text` = "{0}/{1} Selected"),
            #                 multiple = TRUE),
                 ),
    mainPanel(width = 9,
      DT::dataTableOutput("mytable")
      )
    ))

