StudentData.trainLabels <- merge(x = studentStaticData, y = financialData,
                                   by.y = "ID.with.leading", by.x = "StudentID")
StudentData.trainLabels <- merge(x = TrainLabels, y = StudentData.trainLabels,
                                   by.y = "StudentID", by.x = "StudentID")

summary(StudentData.trainLabels)


#install.packages("caret")
library(caret)
intrain <- createDataPartition(StudentData.trainLabels$Dropout,p=0.75,list = FALSE)
train1 <- StudentData.trainLabels[intrain,]
test1 <- StudentData.trainLabels[-intrain,]
trctrl <- trainControl(method = "cv", number = 5)


bag_fit <- train(Dropout ~.-StudentID-Address1-Address2-City-Zip-RegistrationDate -State-cohort-cohort.term, data = train1, method = "treebag", trControl=trctrl)


bag_fit
predictions <- predict(bag_fit, newdata = test1)
confusionMatrix(predictions,test1$Dropout)
#To see the importance of the variables
bagImp <- varImp(bag_fit, scale=TRUE)
bagImp
plot(bagImp)

# predictions <- predict(bag_fit, newdata = financialData.testIDs)
# predictions <- predict(bag_fit, newdata = financialData.testIDs)
# model1_output <- data.frame(financialData.testIDs$StudentID, predictions)
# colnames(model1_output) <- c("StudentID", "Dropout")

model1_output
getwd()
setwd("/cloud/project/")


write.csv(model1_output,file = 'SubmissionFile.csv')