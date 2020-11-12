#12 Nov 2020
#Joonas Pitkänen
#IODS-project
#Data wrangling
#Datasets: RATS and BPRS

#The first dataset documents
#daily growth of some rats
#and the second the evolution 
#the brief psychiatric rating
#scale among 40 men

#Both sets of data relate
#to a methodology book
#Multivariate Analysis for 
#the Behavioral Sciences (2019)
#by Kimmo Vehkalahti and Brian Everitt


#Data source:
#RATS: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt
#BPRS: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt

#Load datasets from the URLs

rats <- 
  read.table(
    "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",
    sep="",header=T)

bprs <- 
  read.table(
    "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",
    sep="",header=T)

str(rats)
str(bprs)

#Transform categorical variables
rats$ID <- as.factor(rats$ID)
rats$Group <- as.factor(rats$Group)

bprs$treatment <- as.factor(bprs$treatment)
bprs$subject <- as.factor(bprs$subject)

library(janitor)

rats <- rats %>% clean_names()
bprs <- bprs %>% clean_names()
#Lower case nicer to handle

#Convert from wide to long
#(Weekly observations from variables
#to repeated observations by individual)

library(tidyverse)

#Pivot_longer is the new function
#which replaces gather()

rats_l <- 
  rats %>% 
  pivot_longer(
    cols=starts_with("wd"),
    names_to="time",
    names_prefix="wd",
    values_to="weight")

bprs_l <- 
  bprs %>% 
  pivot_longer(
    cols=starts_with("week"),
    names_to="week",
    names_prefix="week",
    values_to="bprs")

summary(rats_l)
summary(bprs_l)
str(rats_l)
str(bprs_l)
dim(rats_l)
dim(bprs_l)

#Factors seem correct, as do
#the number of rows:
#BPRS data, 2 classvars,
#9 time points, 20 individual ids
#in both treatment groups =40 individuals
#RATS data: 11 observations from 16 rats
#=176 obs of weight

#Save data

library(openxlsx)
setwd("~/IODS-project/data")
write.xlsx(rats_l, "rats.xlsx")
write.xlsx(bprs_l, "bprs.xlsx")

rm(list=ls())

