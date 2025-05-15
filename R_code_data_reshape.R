#-----------------------------------------------------------------------------#
#---------------------# LTO DATA RESHAPING #----------------------------------#
#-----------------------------------------------------------------------------#

# Feel free to save a copy of this code and the associated csv file and use both to work through the data reshaping and see what the code is actually doing and/or what happens if changes are made.

#----# LOAD IN DATA #----#
setwd('Working Directory/Folder/Folder/etc') #alter names of files inside quotation marks to specify where files can be found 
data<-read.csv('BenthicData.csv',header=T)
View(data)

#----# MATRIX #----#
#install.packages('tidyverse')
library(tidyverse)
#install.packages('reshape')
library(reshape)

matrix<-data %>%
  group_by( transect_no, site_no, site_name, date, distance ) %>%
  pivot_longer(cols=c(7,9,11,13),values_to='species',names_to='S_number')%>%
  pivot_longer(cols=c(7,8,9,10),values_to='percentage',names_to='P_number')

View(matrix)

#----# IDENTIFIERS #----#
matrix$species_num <- as.numeric(gsub("[^0-9]", "", matrix$S_number))
matrix$cover_num <- as.numeric(gsub("[^0-9]", "", matrix$P_number))

#----# FILTER/SUMMARISE DATA #----#
summarised_data <- matrix %>%
  filter(species_num == cover_num) %>%
  select(-S_number, -P_number, -species_num, -cover_num)

#----# OPTIONAL DATA CLEANING #----#
#install.packages('dplyr')
library(dplyr)

clean<-summarised_data%>%
  group_by(transect_no, site_no, year, date, site_name, distance, species)%>%
  drop_na(species)%>%
  dplyr::summarise(total=sum(percentage))
