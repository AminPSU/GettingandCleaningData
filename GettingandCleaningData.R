######## Getting and Cleaning Data Course - Final Project ##########
rm(list = ls())
mainmain=getwd()
# downloading data
setwd("Getting and Cleaning")
if(!file.exists("./GaCdata")){dir.create("./GaCdata")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./GaCdata/DatasetGaC.zip")

# extracting dataset to already created directory
unzip(zipfile="./GaCdata/DatasetGaC.zip",exdir="./GaCdata")

# loading packages
library(dplyr)
library(data.table)
library(tidyr)

setwd("GaCdata/UCI HAR Dataset")
mainDirectory=getwd()

## reading files and making tables
# read subject files
setwd("train")
dataSubjectTrain <- tbl_df(read.table("subject_train.txt"))
setwd(mainDirectory)
setwd("test")
dataSubjectTest  <- tbl_df(read.table("subject_test.txt" ))
setwd(mainDirectory)

# read activity files
setwd("train")
dataActivityTrain <- tbl_df(read.table("Y_train.txt"))
setwd(mainDirectory)
setwd("test")
dataActivityTest  <- tbl_df(read.table("Y_test.txt" ))
setwd(mainDirectory)

# read data files
setwd("train")
dataTrain <- tbl_df(read.table("X_train.txt" ))
setwd(mainDirectory)
setwd("test")
dataTest  <- tbl_df(read.table("X_test.txt" ))
setwd(mainDirectory)

## Part 1.merge the training and the test sets to create one data set. ##

alldataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(alldataSubject, "V1", "subject")
alldataActivity<- rbind(dataActivityTrain, dataActivityTest)
setnames(alldataActivity, "V1", "activityNum")

# combining the DATA training and test files
dataTable <- rbind(dataTrain, dataTest)

# name variables according to feature
dataFeatures <- tbl_df(read.table("features.txt"))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(dataTable) <- dataFeatures$featureName

# modify column names for activity labels
activityLabels<- tbl_df(read.table("activity_labels.txt"))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))

# merge columns
alldataSubjAct<- cbind(alldataSubject, alldataActivity)
dataTable <- cbind(alldataSubjAct, dataTable)

## Part 2. Extracts only the measurements on the mean and standard ##
##         deviation for each measurement.                         ##

# reading "features.txt" and extracting just the mean and standard deviation
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE) #var name

# taking only measurements for the mean and standard deviation and add "subject","activityNum"
dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
dataTable<- subset(dataTable,select=dataFeaturesMeanStd)

## Part 3. Uses descriptive activity names to name the activities ##
##         in the data set.                                       ##

# enter name of activity into dataTable
dataTable <- merge(activityLabels, dataTable , by="activityNum", all.x=TRUE)
dataTable$activityName <- as.character(dataTable$activityName)

# create dataTable with variable means sorted by subject and Activity
dataTable$activityName <- as.character(dataTable$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = dataTable, mean) 
dataTable<- tbl_df(arrange(dataAggr,subject,activityName))

## Part 4. Appropriately labels the data set with descriptive variable names. ##
names(dataTable)<-gsub("std()", "SD", names(dataTable))
names(dataTable)<-gsub("mean()", "MEAN", names(dataTable))
names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
names(dataTable)<-gsub("BodyBody", "Body", names(dataTable))

## Part 5. From the data set in step 4, creates a second, independent ##
##         tidy data set with the average of each variable for each   ##
##         activity and each subject.                                 ##
# writing to text file

setwd(mainDirectory)
write.table(dataTable, "TidyData.txt", row.name=FALSE)

