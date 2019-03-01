install.packages("fBasics")
library(fBasics)

basicStats(financialData$ID.with.leading)
financialData$ID.with.leading <- as.numeric(financialData$ID.with.leading)



financialData.trainLabels <- merge(x = TrainLabels, y = financialData,
                                   by.y = "ID.with.leading", by.x = "StudentID")

summary(financialData.trainLabels)

#Adaptive Boosting ----
install.packages("caret")
library(caret)
intrain <- createDataPartition(financialData.trainLabels$Dropout,p=0.75,list = FALSE)
train1 <- financialData.trainLabels[intrain,]
test1 <- financialData.trainLabels[-intrain,]
trctrl <- trainControl(method = "cv", number = 5)
#Fit Ada Boost
boost_fit <- train(Dropout ~.-StudentID, data = train1, method = "ada")
#To see model details
boost_fit
boost_fit$bestTune
#Plot complexity parameter tuning runs
plot(boost_fit)
#Predict
predictions <- predict(boost_fit, newdata = test1)
#Performance metrics
confusionMatrix(predictions,test1$High)
#To see the importance of the variables
boostImp <- varImp(boost_fit)
boostImp
plot(boostImp)