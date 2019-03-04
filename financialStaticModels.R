financialData.static <- merge(x = studentStaticData, y = financialData,
                                          by.y = "ID.with.leading", by.x = "StudentID")


financialData.static.trainLabels <- merge(x = TrainLabels, y = financialData.static,
                                   by.y = "StudentID", by.x = "StudentID")


financialData.static.trainLabels$Dropout <- as.factor(financialData.static.trainLabels$Dropout)

#install.packages("caret")
library(caret)
intrain <- createDataPartition(financialData.static.trainLabels$Dropout,p=0.75,list = FALSE)
train1 <- financialData.static.trainLabels[intrain,]
test1 <- financialData.static.trainLabels[-intrain,]
trctrl <- trainControl(method = "cv", number = 5)


#bagging 
model1 <- train(Dropout ~ Cohort + CohortTerm + Gender + BirthYear + BirthMonth + HSDipYr
                + HSGPAUnwtd + EnrollmentStatus
                , data = train1, method = "treebag", trControl=trctrl)

predictions1 <- predict(model1, newdata = test1)
confusionMatrix(predictions1, test1$Dropout)$overall[1]


model2 <- train(Dropout ~ NumColCredAttemptTransfer + NumColCredAcceptTransfer
                + CumLoanAtEntry + HighDeg + MathPlacement + EngPlacement 
                + GatewayMathStatus + GatewayEnglishStatus
                , data = train1, method = "treebag", trControl=trctrl)


predictions2 <- predict(model2, newdata = test1)
confusionMatrix(predictions2, test1$Dropout)$overall[1]


model3 <- train(Dropout ~ Marital.Status + Adjusted.Gross.Income + Parent.Adjusted.Gross.Income
                + Father.s.Highest.Grade.Level + Mother.s.Highest.Grade.Level 
                + Housing
                , data = train1, method = "treebag", trControl=trctrl)


predictions3 <- predict(model3, newdata = test1)
confusionMatrix(predictions3, test1$Dropout)$overall[1]

model4 <- train(Dropout ~ X2012.Loan + X2012.Scholarship + X2012.Work.Study + X2012.Grant
                + X2013.Loan + X2013.Scholarship + X2013.Work.Study + X2013.Grant
                + X2014.Loan + X2014.Scholarship + X2014.Work.Study + X2014.Grant
                + X2015.Loan + X2015.Scholarship + X2015.Work.Study + X2015.Grant
                + X2016.Loan + X2016.Scholarship + X2016.Work.Study + X2016.Grant
                + X2017.Loan + X2017.Scholarship + X2017.Work.Study + X2017.Grant
                , data = train1, method = "treebag", trControl=trctrl)


predictions4 <- predict(model4, newdata = test1)
confusionMatrix(predictions4, test1$Dropout)$overall[1]




results <- resamples(list(mod1 = model1, mod2 = model2, mod3 = model3, mod4 = model4)) 
modelCor(results)
#Construct data frame with predictions
predDF <- data.frame( predictions1, predictions2, predictions3, predictions4, class = test1$Dropout)
predDF$class <- as.factor(predDF$class)
#Combine models using random forest
combModFit.rf <- train(class ~ .
                       , method = "rf", data = predDF, distribution = 'binomial')

combModFit <- train(class ~ ., data = predDF, method = "treebag")
combPred.rf <- predict(combModFit.rf, predDF)

confusionMatrix(combPred.rf, predDF$class)$overall[1]



#results on testing data--------

financialData.static.testIDs <- merge(x = testIds, y = financialData.static,
                               by.y = "StudentID", by.x = "StudentID")
predictions1 <- predict(model1, newdata = financialData.static.testIDs)
predictions2 <- predict(model2, newdata = financialData.static.testIDs)
predictions3 <- predict(model3, newdata = financialData.static.testIDs)
predictions4 <- predict(model4, newdata = financialData.static.testIDs)


test_predDF <- data.frame( predictions1, predictions2, predictions3, predictions4)

test_combPred.rf <- predict(combModFit.rf,newdata = test_predDF)

output <- data.frame(financialData.static.testIDs$StudentID, test_combPred.rf)
colnames(output) <- c("StudentID", "Dropout")

getwd()
write.csv(output,file = 'SubmissionFile2.csv')
