
#run_analysis.R
library (dplyr)
library (tidyr)
#library(plyr)
library(reshape2)

#library(Rcpp)

## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

destfile <- "./getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


#file1 <- download.file(url, destfile, mode="wb")

#dlfile1 <- read.csv (url)
setwd ("./")

print(getwd())



list.files("./getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")

#If file does not exisit, download file.
if (!file.exists(destfile)) {download.file(url, destfile, mode="wb")}

# Read the following file first to understand the data and the structure
#subject_test.txt
#y_test.txt
#X_test.txt
#subject_train.txt
#y_train.txt
#X_train.txt
#features.txt
#activity_labels.txt

df_subject_test <- read.table ("./subject_test.txt")

df_y_test <- read.table ("./y_test.txt")

df_X_test <- read.table ("./X_test.txt")

df_subject_train <- read.table ("./subject_train.txt")

df_y_train <- read.table ("./y_train.txt")

df_X_train <- read.table ("./X_train.txt")

df_features <- read.table ("./features.txt")

df_activity_labels <- read.table ("./activity_labels.txt")
names(df_activity_labels) <- c("Activity", "Activity_Label")

#Merge data frames Subjects
subject <- rbind(df_subject_train, df_subject_test)

#Merge Activity
activity <- rbind (df_y_train, df_y_test)

#Merge Features
features <- rbind (df_X_train, df_X_test)


#Test check to name column names from features records
#names(df_X_test) <- t(df_features[2])


# Add column names to features from original features file
names(features) <- t(df_features[2])

# Add column names to activity
names(activity) <- "Activity"

# Add column name to subject
names(subject) <- "Subject"

## 1. Merges the training and the test sets to create one data set.
#Merge the above 3 features, activity and subject into one HUGE big data

bigdata <- cbind(features, activity, subject)

#Extract fields with mean and std (standard deviation)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

#get_mean_std <- grepl("mean|std", names(bigdata), ignore.case=TRUE)
get_mean_std <- grep(".*Mean.*|.*Std.*",names(bigdata), ignore.case=TRUE)
#Append filds 562, 563 which are Activity and Subject
all_fields <- c(get_mean_std, 562, 563)
dim(all_fields)
#Select data with mean, std, 562 and 563
fetch_data <- bigdata[,all_fields]

## 3. Uses descriptive activity names to name the activities in the data set
fetch_data_w_activity <- arrange(join(fetch_data, df_activity_labels), Activity )

## 4. Appropriately labels the data set with descriptive activity names.
# Rename column names to make them more self explanatory
names(fetch_data_w_activity) <- gsub("-mean()", "Mean", names(fetch_data_w_activity), ignore.case = TRUE)
names(fetch_data_w_activity) <- gsub("-std()", "STD", names(fetch_data_w_activity), ignore.case = TRUE)
names(fetch_data_w_activity) <- gsub("BodyBody", "Body", names(fetch_data_w_activity), ignore.case = TRUE)
names(fetch_data_w_activity) <- gsub("^f", "Freq", names(fetch_data_w_activity), ignore.case = TRUE)
names(fetch_data_w_activity) <- gsub("-freq()", "Freq", names(fetch_data_w_activity), ignore.case = TRUE)
names(fetch_data_w_activity) <- gsub("^t", "Time", names(fetch_data_w_activity), ignore.case = TRUE)
#names(fetch_data_w_activity) <- gsub("^t", "Time", names(fetch_data_w_activity), ignore.case = TRUE)
#names(fetch_data_w_activity) <- gsub("^t", "Time", names(fetch_data_w_activity), ignore.case = TRUE)

names(fetch_data_w_activity) <- gsub("()", "", names(fetch_data_w_activity), ignore.case = TRUE)



## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Rearrange the data to wide format with melt function with Subject, Activity and Activity_Label
melt_data <- melt(fetch_data_w_activity, id = c("Subject", "Activity", "Activity_Label"))

#Tidaydata or rearrange using dcast and find mean
tidydata <- dcast(melt_data, Subject + Activity_Label ~ variable, mean)
#print(head(tidydata))
#Write final data into a file
write.table (tidydata, "./Tidydata.txt", row.names=FALSE)

#print(tail(tidydata))