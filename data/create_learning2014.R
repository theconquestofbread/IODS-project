#R code for creating the data used
#in the IODS course project
#Data set name: learning2014
#Data source: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt 
#More information on data: https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS2-meta.txt
#Author: Joonas Pitkänen
#Date: 2 Nov 2020

#Read in the data:
learning2014 <- read.table(
"http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt",
sep="\t", header=T)

#Upload some central packages
library(tidyverse)

#Check dimensions and structure
dim(learning2014)
str(learning2014)
head(learning2014)

#Create a dataset containing
#background information (Age, gender),
#general attitude towards statistics
#(Attitude), test score (?) (Points),
#and means of questions related to  
#approaches to learning (deep learning, D*,
#strategic learning, ST*, surface learning,
#SU*)

#Strings of question names for each dimension
deep_questions <- c(
  "D03", "D11", "D19", "D27", 
  "D07", "D14", "D22", "D30",
  "D06",  "D15", "D23", "D31")
surface_questions <- c(
  "SU02","SU10","SU18","SU26",
  "SU05","SU13","SU21","SU29",
  "SU08","SU16","SU24","SU32")
strategic_questions <- c(
  "ST01","ST09","ST17","ST25",
  "ST04","ST12","ST20","ST28")

#Deep learning
learning2014$deep <-
  learning2014 %>%
  select(all_of(deep_questions)) %>%
  rowMeans()
#Strategic learning
learning2014$stra <-
  learning2014 %>%
  select(all_of(strategic_questions)) %>%
  rowMeans()
#Surface learning
learning2014$surf <-
  learning2014 %>%
  select(all_of(surface_questions)) %>%
  rowMeans()

#Select final columns needed in analyses
learning_2014 <-
  learning2014 %>%
  select(c("Age","gender",
           "Attitude","Points",
           "deep","stra","surf"))

#Some tidying of data
#rename columns
colnames(learning_2014)
colnames(learning_2014)[1] <- "age"
colnames(learning_2014)[3] <- "attitude"
colnames(learning_2014)[4] <- "points"
#Exclude observations where points=0
learning_2014 <-
  learning_2014 %>% filter(points!=0)

#In the instructions, it was asked
#that all combination variables would be
#scaled by taking the mean. I am not 100%
#whether this is what was expected but I
#think that there is also one combination
#variable (sum variable) attitude, which
#consists of 10 questions. Thus, I'll scale
#attitude by dividing it by 10.

learning_2014$attitude <-
  learning_2014$attitude/10

#Check dimensions and structure
str(learning_2014)
dim(learning_2014)

#Everything seems to be in order
#Saving the data

setwd("~/IODS-project/data")
write.table(learning_2014,"learning_2014.txt")

#Clear environment
rm(list=ls())

#Check the data
learning_2014 <- read.table("learning_2014.txt")
str(learning_2014)
dim(learning_2014)
head(learning_2014)

#Should be correct

rm(list=ls())