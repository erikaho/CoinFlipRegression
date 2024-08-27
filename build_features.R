rm(list = ls())
library(data.table)

train<-fread('./project/volume/data/raw/train_file.csv')
test<-fread('./project/volume/data/raw/test_file.csv')
