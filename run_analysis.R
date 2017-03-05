########################################################
# Getting and Cleaning Data Course Project             #
# By: Paulo Morone                                     #
########################################################

# 1. Step - Download and Unzip the data
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest <- "./data/CourseProject"
destzip <- "./data/CourseProject/data.zip"

if(!file.exists(dest)){dir.create(dest)}

#download.file(fileurl, destfile = destzip)

unzip(zipfile = destzip, exdir = dest)

# 2. Step - Load necessary data and rename the column names
# Feature file:
features <- read.table('./data/CourseProject/UCI HAR Dataset/features.txt')

# Activity file:
activity = read.table('./data/CourseProject/UCI HAR Dataset/activity_labels.txt')
colnames(activity) <- c('activityId','activityType')

# Trainings files:
x_train <- read.table("./data/CourseProject/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/CourseProject/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/CourseProject/UCI HAR Dataset/train/subject_train.txt")
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

# Testing files:
x_test <- read.table("./data/CourseProject/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/CourseProject/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/CourseProject/UCI HAR Dataset/test/subject_test.txt")
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

# 3. Step - Merge the data to create one dataset
train <- cbind(y_train, subject_train, x_train)
test <- cbind(y_test, subject_test, x_test)
mrg_data <- rbind(train, test)
Names <- colnames(mrg_data)

# 4. Step - Extracts the mean and SD for each measurement

mean_and_std <- (grepl("activityId" , Names) | 
                     grepl("subjectId" , Names) | 
                     grepl("mean.." , Names) | 
                     grepl("std.." , Names) 
)


setForMeanAndStd <- mrg_data[ , mean_and_std == TRUE]

# 5. Step - Descriptive activity names to name the activities in the dataset

setWithActivityNames <- merge(setForMeanAndStd, activity,
                              by='activityId',
                              all.x=TRUE)

# 6. Step - Second dataset

secdata <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secdata <- secdata[order(secdata$subjectId, secdata$activityId),]
write.table(secdata, "TIDY.txt", row.name=FALSE)

