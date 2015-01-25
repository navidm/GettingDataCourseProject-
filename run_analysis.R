# Before running this script make sure to set the working dirctory 
# to the folder contaning datasets (the one downloaded for Course Project)
# and copy this script into that folder

# Setting working directory to the project forlder
setwd("The address to the folder contaning datasets and this script")

#  Step 1
# Reading Test dataset
testData      <- read.table("./test/X_test.txt", header = FALSE)
testLabels    <- read.table("./test/Y_test.txt", header = FALSE)
testSubjects  <- read.table("./test/subject_test.txt", header = FALSE)

# Reading Train dataset
trainData     <- read.table("./train/X_train.txt", header = FALSE)
trainLabels   <- read.table("./train/Y_train.txt", header = FALSE)
trainSubjects <- read.table("./train/subject_train.txt", header = FALSE)

# Reading feature names
featureNames  <- read.table("./features.txt", header = FALSE)



# Adding labels and subjects to datasets
testData  <- cbind(testLabels,testData)
testData  <- cbind(testSubjects,testData)
trainData <- cbind(trainLabels,trainData)
trainData <- cbind(trainSubjects,trainData)

# Creating a combined dataset
combinedDS <- rbind(testData , trainData )

# Assigning variable names to the dataset. note that we start from 2 to skip 
# the label names which contains subject id.

colNames <- featureNames$V2
colNames <- as.character(colNames)
# There are duplicate (similar) feature names. The code bellow add a suffix to 
# them to make them unique
colNames <- make.names(colNames , unique=TRUE)

names(combinedDS)[1] <- paste("subjectID")
names(combinedDS)[2] <- paste("activity")

for(i in 3:length(combinedDS)){
    names(combinedDS)[i] <- paste(colNames[i-2])  
}

# Step 3
# Finding "Mean" and "Standard deviation" variables. Here we find the column
# numbers and select those columns from the data set
vNames <- featureNames$V2
b <- grep("mean"     ,vNames)
b <- c(b,grep("Mean" ,vNames))
b <- c(b,grep("std"  ,vNames))

# Remember we added the first two columns (subject id, activity_id) we want
# those columns to be in the output (col 1,2) then we add to the column
# numbers and merge the mean and std

library(dplyr)
# Selecting SubjectID, activityID and all mean and std variables
extMeasureDS <- select(combinedDS, 1,2, b+2)

# Step3
# Updating activity names to more describtive ones
activitiesDS     <- extMeasureDS[,2]
activitiesDS     <- gsub(1,"working",activitiesDS)
activitiesDS     <- gsub(2,"walkingUp",activitiesDS)
activitiesDS     <- gsub(3,"walkingDown",activitiesDS)
activitiesDS     <- gsub(4,"sitting",activitiesDS)
activitiesDS     <- gsub(5,"standing",activitiesDS)
activitiesDS     <- gsub(6,"lying",activitiesDS)
extMeasureDS[,2] <- activitiesDS


# Step 4
# Updating variable names to more descriptive ones Note that since 
# the namings are too long,for the sake of readability, CamelCase were usee 
names(extMeasureDS) <- gsub("tBodyAccJerk","linearAccelerationTime" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("tBodyAcc","bodyAccelerationTime" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("tBodyGyroJerk","angularVelocityTime" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("tBodyGyro","bodyVelocityTime" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("tBodyAccMag","bodyAccelerationMagnitudeTime" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("tBodyAccJerkMag","linearAccelerationMagnitudeTime" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("tGravityAcc","gravityAccelerationTime" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("tGravityAccMag","gravityAccelerationMagnitudeTime" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("tBodyGyroJerkMag","angularVelocityMagnitudeTime" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("tBodyGyroMag","bodyVelocityMagnitudeTime" ,names(extMeasureDS))

names(extMeasureDS) <- gsub("fBodyAccJerk","linearAccelerationFrequency" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("fBodyAcc","bodyAccelerationFrequency" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("fBodyGyro","bodyVelocityFrequency" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("fBodyAccMag","bodyAccelerationMagnitudeFrequency" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("fBodyBodyAccJerkMag","bodyLinearAccelerationMagnitudeFrequency" 
                            ,names(extMeasureDS))
names(extMeasureDS) <- gsub("fBodyBodyGyroMag","bodyVelocityMagnitudeFrequency" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("fBodyBodyGyroJerkMag","angularVelocityMagnitudeFrequency" ,names(extMeasureDS))

# Getting rid if dots
names(extMeasureDS) <- gsub("\\.","" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("\\..","" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("\\...","" ,names(extMeasureDS))

names(extMeasureDS) <- gsub("std","Std" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("mean","Mean" ,names(extMeasureDS))

names(extMeasureDS) <- gsub("angleYgravityMean","angleGravityMeanY" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("angleXgravityMean","angleGravityMeanX" ,names(extMeasureDS))
names(extMeasureDS) <- gsub("angleZgravityMean","angleGravityMeanZ" ,names(extMeasureDS))

# Step 5 
# Calculating mean, per all the subjects anc activities. In the first step we group the 
# data set by subjectID and activity and pass the result to the summarise_each function 
# to calculate the mean for all the variables
aggregatedDS <- summarise_each(group_by(extMeasureDS, subjectID,activity),funs(mean))

write.table(aggregatedDS, file = "experimentTidyDS.txt", row.name = FALSE)
