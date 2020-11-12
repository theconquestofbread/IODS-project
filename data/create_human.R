#11 Nov 2011
#Joonas Pitkänen
#IODS-project
#Data wrangling (weeks 4 and 5)

#United Nations data on
#1. Human development index (HDI)
#2. Gender inequality index
#The datasets comprise of the indicators
#used to calculate the corresponding
#indices, as well as the scores in each
#country in the world (or UN?)
#Original data and Metadata available:
#here: http://hdr.undp.org/en/content/human-development-index-hdi
#and here: http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

library(tidyverse)
library(openxlsx)
setwd("~/IODS-project/data")


hd <- 
  read.csv(
    "http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv",
    stringsAsFactors = F)

gii <- 
  read.csv(
    "http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", 
                stringsAsFactors = F, 
                na.strings = "..")

dim(hd)
dim(gii)
str(hd)
str(gii)

summary(gii)
summary(hd)

#clean names with janitor
library(janitor)
hd <- hd %>% clean_names()
gii <- gii %>% clean_names()

#Rename columns

names(hd)
names(hd)[3] <- "hdi"
names(hd)[4] <- "life_exp"
names(hd)[5] <- "exp_edu"
names(hd)[6] <- "mean_edu"
names(hd)[7] <- "gni"
names(hd)[8] <- "gni_rank"

names(gii)
names(gii)[3] <- "gii"
names(gii)[4] <- "maternal_mx"
names(gii)[5] <- "teen_births"
names(gii)[6] <- "female_parl"
names(gii)[7] <- "female_edu"
names(gii)[8] <- "male_edu"
names(gii)[9] <- "female_lf"
names(gii)[10] <- "male_lf"

#Transform GII data

#Male/female ratio of secondary educated
#individuals

gii <- mutate(
  gii,edu_ratio=female_edu/male_edu)
gii <- mutate(
  gii,lab_ratio=female_lf/male_lf)

summary(gii)

#Combine datasets

human <- inner_join(
  hd,gii,by="country")

summary(human)
dim(human)

#looks correct (195 countries, 19 vars)

#Save & reload to test
write.xlsx(human, file="human.xlsx")

rm(list=ls())

human <- read.xlsx("human.xlsx")

summary(human)
dim(human)

#Further manipulation (Week 4)
#GNI to numeric
summary(human$gni)
str(human$gni)

library(stringr)
human$gni <- 
  as.numeric(
    str_replace(human$gni, 
            pattern=",",
            replace=""))

summary(human$gni)
str(human$gni)

#Limit data + remove NAs 
names(human)
keep_vars <- 
  c("country","edu_ratio",
    "lab_ratio","exp_edu",
    "life_exp","gni",
    "maternal_mx","teen_births",
    "female_parl")

human_ <- 
  human %>%
    select(all_of(keep_vars)) %>%
  drop_na()

#Drop last seven rows
#(not countries)

last_7 <- nrow(human_)-7

human_ <- 
  human_[1:last_7,]

#Country names to row names
rownames(human_) <- human_$country

#Drop country variable

human_ <- select(human_,-country)

summary(human_)
dim(human_)

#Should be okay (155 countries, 8 vars)
#Save & test

write.xlsx(human_, file="human.xlsx")

rm(list=ls())

human <- read.xlsx("human.xlsx")

summary(human)
dim(human)
