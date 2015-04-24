setwd("~/Dropbox/courses/getting and cleaning data/Project Assignment/UCI HAR Dataset")
library(plyr)
##Load plyr
##1. Load the data from text files into R data.frame.

##x_train is the processed value for training
##y_train is the activity names
##subject_train is the id of each test participate whose test results is included in the training dataset.

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

##x_test is the processed value for testing
##y_test is the activity names
##subject_test contains the id of each test participate whose test results is included in the test dataset.
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

## create x_combine by combining x_train and x_test
x_combine <- rbind(x_train, x_test)

##create y_combine by combining y_train and y_test
y_combine <- rbind(y_train, y_test)

##create subject_combine by combing subject_train and subject_test
subject_combine <- rbind(subject_train, subject_test)

## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 

## features contain name of the calculation loaded
## they are used as names of the x_combine
features <- read.table("features.txt")

## get only columns with mean() or std() in features
mean_and_std <- grep("-(mean|std)\\(\\)", features[, 2])

##subset the mean() and std() columns
x_mean_std <-x_combine[,mean_and_std]

##update the column names
names(x_mean_std) <- features[mean_and_std, 2]

##3.Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")

##update values with correct activity names, turn the y_combine into a row
y_combine[,1] <- activities[y_combine[,1],2]

##change the name of y_combine
names(y_combine) <-"activity"

##4.Appropriately labels the data set with descriptive variable names.
##change the name of subject_combine
names(subject_combine) <- "subject"

##combine all the data in a single data set
dataset <- cbind(x_mean_std, y_combine, subject_combine)

##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
length(dataset)
##column mean for column 1:66 but last two are activity and subject
dataset2 <- ddply(dataset, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(dataset2, "dataset2.txt", row.name=FALSE)
