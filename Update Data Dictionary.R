## P20 WIN DATA DICTIONARY UPDATE SCRIPT ##
# This script is used to merge the agency data dictionary files into one master P20 WIN Data Dictionary file
# This is the file uploaded to the P20 WIN Data Dictionary App

# Ensure you have the correct working directory established. The working directory should be where your Github folder is stored. 
# Session -> Set Working Directory -> Choose Directory

#packages may require initial install (install.packages(""))
library(readxl)
library(xlsx)
library(dplyr)

#### Reading in the Data Dictionaries - add row for new agencies ####
CCEH <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/CCEH/CCEH_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)
CCIC <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/CCIC/CCIC_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)
CSCU <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/CSCU/CSCU_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)
DCF <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/DCF/DCF_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)
DHMAS <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/DMHAS/DMHAS_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)
DOL <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/DOL/DOL_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)
OEC <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/OEC/OEC_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)
OHE <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/OHE/OHE_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)
SDE <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/SDE/SDE_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)
UConn <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/UConn/UConn_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)
CSSD <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/CSSD/CSSD_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)
CTECS <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/CTECS/CTECS_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)
DOC <- read_excel("GitHub/Data-Dictionaries/Data Dictionaries (Upload Here)/DOC/DOC_Data_Dictionary.xlsx") %>% 
  mutate_all(as.character)


#### Creating P20 WIN Data Dictionary ####
P20WIN_Data_Dictionary <- rbind(CCEH,CCIC,CSCU,DCF,DHMAS,DOL,CSSD,OEC,OHE,SDE,UConn,CSSD,CTECS,DOC)
P20WIN_Data_Dictionary$`Click to View More` <- '&oplus;' #adding the column that will be used to expand the selection.
P20WIN_Data_Dictionary <- P20WIN_Data_Dictionary[,c(8,1:7)] #moving the added column to be the first column
P20WIN_Data_Dictionary[is.na(P20WIN_Data_Dictionary)] <- "Not Available"

#### Saving P20 WIN Data Dictionary ####
write.xlsx(as.data.frame(P20WIN_Data_Dictionary),"GitHub/Data-Dictionaries/P20 WIN Data Dictionary/P20WIN_Data_Dictionary.xlsx", row.names = FALSE)
