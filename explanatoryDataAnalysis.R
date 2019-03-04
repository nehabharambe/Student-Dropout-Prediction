install.packages("fBasics")
library(fBasics)

basicStats(financialData$Marital.Status)

financialData$Marital.Status <- sub("^$", "Unknown", financialData$Marital.Status)
financialData$Marital.Status <- as.factor(financialData$Marital.Status)

financialData$Housing <- sub("^$", "Unknown", financialData$Housing)
financialData$Housing <- as.factor(financialData$Housing)


financialData$Father.s.Highest.Grade.Level <- sub("^$", "Unknown", financialData$Father.s.Highest.Grade.Level)
financialData$Father.s.Highest.Grade.Level <- as.factor(financialData$Father.s.Highest.Grade.Level)

financialData$Mother.s.Highest.Grade.Level <- sub("^$", "Unknown", financialData$Mother.s.Highest.Grade.Level)
financialData$Mother.s.Highest.Grade.Level <- as.factor(financialData$Mother.s.Highest.Grade.Level)

library(imputeTS)
financialData <- na.replace(financialData, 0)


#Merge static Data  -------

studentStaticData <- rbind(stFall2011,stFall2012, stFall2013, stFall2014, stFall2015, stFall2016, stSpring2012, stSpring2013, stSpring2014, stSpring2015, stSpring2016)

summary(studentStaticData)
studentStaticData$Campus <- NULL


studentStaticData$Gender <- as.factor(studentStaticData$Gender)
studentStaticData$CohortTerm <- as.factor(studentStaticData$CohortTerm)

#studentStaticData$Hispanic <- ifelse(studentStaticData$Hispanic == -1, NA, studentStaticData$Hispanic)
studentStaticData$Hispanic <- as.factor(studentStaticData$Hispanic)

#studentStaticData$AmericanIndian <- ifelse(studentStaticData$AmericanIndian == -1, NA, studentStaticData$AmericanIndian)
studentStaticData$AmericanIndian <- as.factor(studentStaticData$AmericanIndian)

#studentStaticData$Asian <- ifelse(studentStaticData$Asian == -1, NA, studentStaticData$Asian)
studentStaticData$Asian <- as.factor(studentStaticData$Asian)

#studentStaticData$Black <- ifelse(studentStaticData$Black == -1, NA, studentStaticData$Black)
studentStaticData$Black <- as.factor(studentStaticData$Black)

#studentStaticData$NativeHawaiian <- ifelse(studentStaticData$NativeHawaiian == -1, NA, studentStaticData$NativeHawaiian)
studentStaticData$NativeHawaiian <- as.factor(studentStaticData$NativeHawaiian)

#studentStaticData$White <- ifelse(studentStaticData$White == -1, NA, studentStaticData$White)
studentStaticData$White <- as.factor(studentStaticData$White)

#studentStaticData$TwoOrMoreRace <- ifelse(studentStaticData$TwoOrMoreRace == -1, NA, studentStaticData$TwoOrMoreRace)
studentStaticData$TwoOrMoreRace <- as.factor(studentStaticData$TwoOrMoreRace)

studentStaticData$HSDip <- as.factor(studentStaticData$HSDip)
studentStaticData$HSGPAUnwtd <- as.factor(studentStaticData$HSGPAUnwtd)
studentStaticData$HSGPAWtd <- as.factor(studentStaticData$HSGPAWtd)
studentStaticData$FirstGen <- as.factor(studentStaticData$FirstGen)
studentStaticData$DualHSSummerEnroll <- as.factor(studentStaticData$DualHSSummerEnroll)
studentStaticData$EnrollmentStatus <- as.factor(studentStaticData$EnrollmentStatus)
studentStaticData$HighDeg <- as.factor(studentStaticData$HighDeg)
studentStaticData$MathPlacement <- as.factor(studentStaticData$MathPlacement)
studentStaticData$EngPlacement <- as.factor(studentStaticData$EngPlacement)
studentStaticData$GatewayMathStatus <- as.factor(studentStaticData$GatewayMathStatus)
studentStaticData$GatewayEnglishStatus <- as.factor(studentStaticData$GatewayEnglishStatus)
studentStaticData$BirthYear <- as.factor(studentStaticData$BirthYear)
studentStaticData$BirthMonth <- as.factor(studentStaticData$BirthMonth)

summary(studentStaticData)


studentStaticData$Campus <- NULL
studentStaticData$HSGPAWtd <- NULL
studentStaticData$FirstGen <- NULL
studentStaticData$DualHSSummerEnroll <- NULL
#StudentData.trainLabels$State <- sub("^$", "Unknown", financialData$State)

library(imputeTS)
studentStaticData$Zip <- na.replace(studentStaticData$Zip, 0)

#library(imputeTS)
studentStaticData$BirthYear <- na.replace(studentStaticData$BirthYear, 1989)


###### Merge progress data --------

studentProgressData <- rbind(spFall2011,spFall2012,spFall2013,spFall2014,spFall2015,spFall2016,spSpring2012,spSpring2013,spSpring2014,spSpring2015,spSpring2016,spSpring2017,spSum2012,spSum2013,spSum2014,spSum2015,spSum2016,spSum2017)

studentProgressData$CohortTerm <- as.factor(studentProgressData$CohortTerm)
studentProgressData$Term <- as.factor(studentProgressData$Term)
studentProgressData$CompleteDevMath <- as.factor(studentProgressData$CompleteDevMath)
studentProgressData$CompleteDevEnglish <- as.factor(studentProgressData$CompleteDevEnglish)
studentProgressData$Major1 <- as.factor(studentProgressData$Major1)
studentProgressData$Major2 <- as.factor(studentProgressData$Major2)
studentProgressData$Complete1 <- as.factor(studentProgressData$Complete1)
studentProgressData$Complete2 <- as.factor(studentProgressData$Complete2)
studentProgressData$TransferIntent <- as.factor(studentProgressData$TransferIntent)
studentProgressData$DegreeTypeSought <- as.factor(studentProgressData$DegreeTypeSought)






combinedStudentData <- merge(x = studentProgressData, y = studentStaticData,
                             by = c("StudentID","Cohort","CohortTerm"))
