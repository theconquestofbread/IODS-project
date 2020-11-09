#Data wrangling exercise
#9 November 2011
#Joonas Pitkänen

#In this exercise, I am using data on students'
#school performance and alcohol use
#in two Portuguese schools 
#(Cortez & Silva 2008).

#Data Reference: P. Cortez and A. Silva. 
#Using Data Mining to Predict Secondary 
#School Student Performance. In A. Brito 
#and J. Teixeira Eds., Proceedings of 5th 
#FUture BUsiness TEChnology Conference (FUBUTEC 2008) 
#pp. 5-12, Porto, Portugal, April, 2008, 
#EUROSIS, ISBN 978-9077381-39-7. 
#https://archive.ics.uci.edu/ml/datasets/Student+Performance

library(tidyverse)
getwd()
setwd("~/IODS-project/data")

#Read in data on performance in math
math <- read.csv("student-mat.csv",sep=";")
head(math)
str(math)
dim(math)

#Read in data on performance in Portuguese
por <- read.csv("student-por.csv",sep=";")
head(por)
str(por)
dim(por)

#Join the two datasets
#Since there are no respondent identifiers,
#I use a large number of background
#variables and hope for no duplicates

join_by <- c("school","sex",
             "age","address",
             "famsize","Pstatus",
             "Medu","Fedu","Mjob",
             "Fjob","reason",
             "nursery","internet")

#There are much more students in the por data
#but same number of variables
#Inner_join keeps only observations 
#that match
math_por <- 
  inner_join(math, por, by = join_by)
head(math_por)
str(math_por)
dim(math_por)

#Now we have possibly duplicate answers
#from the two sets of data
#I use the Datacamp solution here 

# create a new data frame 
#with only the joined columns
alc <- select(math_por, all_of(join_by))

# the columns in the 
#datasets which were not used 
#for joining the data
notjoined_columns <-
  colnames(math)[!colnames(math) %in% join_by]

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' 
  #with the same original name
  two_columns <- 
    select(math_por, 
           starts_with(column_name))
  # select the first column 
  #vector of those two columns
  first_column <- 
    select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average 
    #of each row of the two columns and
    # add the resulting vector to the 
    #alc data frame
    alc[column_name] <- 
      round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector 
    #to the alc data frame
    alc[column_name] <- first_column
  }
}
glimpse(alc)
#Looks okay

#Create average daily alcohol use
#by combining weekday and weekend use
alc <- 
  mutate(alc, 
         alc_use = (Dalc + Walc) / 2)

# Define high use as TRUE if alcohol use
# greater than 2
alc <- 
  mutate(alc, 
         high_use = alc_use > 2)

dim(alc)

#The data contains 382 observations
#and 35 variables, so should be correct

getwd()
write.csv(alc,"alc_data.csv",row.names=F)
rm(list=ls())
getwd()

alc_data <- read.csv("alc_data.csv")
dim(alc_data)
