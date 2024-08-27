rm(list = ls())
library(dplyr)
library(randomForest)
library(data.table)
library(Metrics)
library(caret)
set.seed(77)

#read data into environment
train<-fread('./project/volume/data/raw/train_file.csv')
test<-fread('./project/volume/data/raw/test_file.csv')
submit<-fread('./project/volume/data/raw/samp_sub.csv')


#tried looking up other models and found randomForest....did not provide a score higher than when I used glm or lm model 
#rf_model <- randomForest(result ~ V1 + V2 +V3 + V4 +V5 + V6 +V7 + V8 +V9 + V10, data = train)
#submit$result <- predict(rf_model, newdata = test)

test_y<-submit$result
train_y<-train$result
test$result<-0

master<- rbind(train,test)

#class dummies model
dummies<-dummyVars(result~.,data=master)
train<-predict(dummies, newdata = train)
test<- predict(dummies, newdata = test)

#reformat from matrix back into data table
train<- data.table(train)
train$result <- train_y
test<- data.table(test)



#glm model
glm_model<-glm(result ~ V1 + V2 +V3 + V4 +V5 + V6 +V7 + V8 +V9 + V10, data = train, family = "binomial")
saveRDS(glm_model,'./project/volume/models/result_glm.model')

#predicting result using glm_model with test data
submit$result <- predict(glm_model, newdata = test, type = "response")
summary(glm_model)





#lm_model<-lm(result~., data = train)
#summary(lm_model)

#predicting result using lm_model with test data
#test$result<- predict(lm_model, newdata = test)
#submit$result<- test$result



saveRDS(dummies,'./project/volume/models/result_lm.dummies')
#saveRDS(lm_model,'./project/volume/models/result_lm.model')

fwrite(submit,'./project/volume/data/processed/submit1.csv')


