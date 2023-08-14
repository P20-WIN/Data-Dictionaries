## P20 WIN DATA DICTIONARY UPDATE SCRIPT ##
# This script is used to merge the agency data dictionary files into one master P20 WIN Data Dictionary file
# This is the file uploaded to the P20 WIN Data Dictionary App


#install.packages("readxl")
library(readxl)
library(xlsx)

#### Reading in the Data Dictionaries - add row for new agencies ####
CCEH <- read_excel("Data Dictionaries (Upload Here)/CCEH/CCEH_Data_Dictionary.xlsx")
CCIC <- read_excel("Data Dictionaries (Upload Here)/CCIC/CCIC_Data_Dictionary.xlsx")
CSCU <- read_excel("Data Dictionaries (Upload Here)/CSCU/CSCU_Data_Dictionary.xlsx")
DCF <- read_excel("Data Dictionaries (Upload Here)/DCF/DCF_Data_Dictionary.xlsx")
DHMAS <- read_excel("Data Dictionaries (Upload Here)/DMHAS/DMHAS_Data_Dictionary.xlsx")
DOL <- read_excel("Data Dictionaries (Upload Here)/DOL/DOL_Data_Dictionary.xlsx")
OEC <- read_excel("Data Dictionaries (Upload Here)/OEC/OEC_Data_Dictionary.xlsx")
OHE <- read_excel("Data Dictionaries (Upload Here)/OHE/OHE_Data_Dictionary.xlsx")
SDE <- read_excel("Data Dictionaries (Upload Here)/SDE/SDE_Data_Dictionary.xlsx")
UConn <- read_excel("Data Dictionaries (Upload Here)/UConn/UConn_Data_Dictionary.xlsx")
CSSD <- read_excel("Data Dictionaries (Upload Here)/CSSD/CSSD_Data_Dictionary.xlsx")
CTECS <- read_excel("Data Dictionaries (Upload Here)/CTECS/CTECS_Data_Dictionary.xlsx")

#### Creating P20 WIN Data Dictionary ####
P20WIN_Data_Dictionary <- rbind(CCEH,CCIC,CSCU,DCF,DHMAS,DOL,CSSD, OEC,OHE,SDE,UConn, CSSD, CTECS)
P20WIN_Data_Dictionary$`Click to View More` <- '&oplus;' #adding the column that will be used to expand the selection.
P20WIN_Data_Dictionary <- P20WIN_Data_Dictionary[,c(8,1:7)] #moving the added column to be the first column
P20WIN_Data_Dictionary[is.na(P20WIN_Data_Dictionary)] <- "Not Available"

#### Saving P20 WIN Data Dictionary ####
write.xlsx(as.data.frame(P20WIN_Data_Dictionary),"P20 WIN Data Dictionary/P20WIN_Data_Dictionary.xlsx", row.names = FALSE)
