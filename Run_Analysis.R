library(dplyr)
library(plyr)
dir<-"/Users/lu/Documents/COURSERA/John Hopkins Data Science/Getting and cleaning data"
setwd(dir)
datUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#destination zip
destfile<-paste0(getwd(),"/","wearable.zip")
#download zip file
download.file(datUrl,destfile)
#unzip file
unzip("wearable.zip")

setwd("./UCI HAR Dataset")

#read activity labels
activity_labels<-read.table("activity_labels.txt")

#read features
features<-read.table("features.txt")

#read test data
x_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/Y_test.txt")
subject_test<-read.table("./test/subject_test.txt") 

#read train data
x_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/Y_train.txt")
subject_train<-read.table("./train/subject_train.txt")


#Merge the training and the test sets to create one data set.
x_data<-rbind(x_test,x_train)
y_data<-rbind(y_test,y_train)
subject_data<-rbind(subject_test,subject_train)

#Extracts only the measurements on the mean and standard deviation for each measurement.
mean_and_std_features <- grep("-(mean|std)", features[, 2])
x_data <- x_data[, mean_and_std_features]
names(x_data) <- features[mean_and_std_features, 2]


# Use descriptive activity names to name the activities in the data set
y_data[, 1] <- activitylabels[y_data[, 1], 2]
names(y_data) <- "activity"

# Appropriately label the data set with descriptive variable names
names(subject_data) <- "subject"

# Put all the data in a single data set
cleaned_data <- cbind(x_data, y_data, subject_data)

# creates a second, independent tidy data set with the average of each variable for each activity and each subject.
averages_data <- ddply(cleaned_data, .(subject, activity), function(x) colMeans(x[, 1:81]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)
