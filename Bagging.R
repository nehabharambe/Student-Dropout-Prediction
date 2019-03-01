financialData.trainLabels <- merge(x = TrainLabels, y = financialData,
                                   by.y = "ID.with.leading", by.x = "StudentID")

financialData.testIDs <- merge(x = testIds, y = financialData,
                               by.y = "ID.with.leading", by.x = "StudentID")
financialData.testIDs

financialData.trainLabels$Dropout <- as.factor(financialData.trainLabels$Dropout)

library(imputeTS)
financialData.trainLabels <- na.replace(financialData.trainLabels, 0)
Store <- na.replace(Store,0)
summary(Store)
summary(financialData$Marital.Status)


#Adaptive Boosting ----
install.packages("caret")
library(caret)
intrain <- createDataPartition(financialData.trainLabels$Dropout,p=0.75,list = FALSE)
train1 <- financialData.trainLabels[intrain,]
test1 <- financialData.trainLabels[-intrain,]
trctrl <- trainControl(method = "cv", number = 5)


#bagging 
bag_fit <- train(Dropout ~.-StudentID, data = train1, method = "treebag", trControl=trctrl)


bag_fit
predictions <- predict(bag_fit, newdata = test1)
confusionMatrix(predictions,test1$Dropout)
#To see the importance of the variables
bagImp <- varImp(bag_fit, scale=TRUE)
bagImp
plot(bagImp)

predictions <- predict(bag_fit, newdata = financialData.testIDs)
predictions <- predict(bag_fit, newdata = financialData.testIDs)
model1_output <- data.frame(financialData.testIDs$StudentID, predictions)
colnames(model1_output) <- c("StudentID", "Dropout")

model1_output
getwd()
setwd("/cloud/project/")


write.csv(model1_output,file = 'SubmissionFile.csv')