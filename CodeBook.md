#CodeBook

This document describes the data and transofrmations used by run_analysis.R and the definition of variables in Tidydata.txt

#Dataset Used

This data is obtained from "Human Activity Recognition Using Smartphones Data Set". The data linked are collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

The data set used can be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
#Input Data Set

The input data containts the following data files:

X_train.txt contains variable features that are intended for training.

y_train.txt contains the activities corresponding to X_train.txt.

subject_train.txt contains information on the subjects from whom data is collected.

X_test.txt contains variable features that are intended for testing.

y_test.txt contains the activities corresponding to X_test.txt.

subject_test.txt contains information on the subjects from whom data is collected.

activity_labels.txt contains metadata on the different types of activities.

features.txt contains the name of the features in the data sets.

#Merge data frames Subjects
subject <- rbind(df_subject_train, df_subject_test)

#Merge Activity
activity <- rbind (df_y_train, df_y_test)

#Merge Features
features <- rbind (df_X_train, df_X_test)


## 1. Merges the training and the test sets to create one data set.
bigdata <- cbind(features, activity, subject)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
fetch_data <- bigdata[,all_fields]

## 3. Uses descriptive activity names to name the activities in the data set
fetch_data_w_activity <- arrange(join(fetch_data, df_activity_labels), Activity )

## 4. Appropriately labels the data set with descriptive activity names.
names(fetch_data_w_activity) <- gsub("-mean()", "Mean", names(fetch_data_w_activity), ignore.case = TRUE)
names(fetch_data_w_activity) <- gsub("-std()", "STD", names(fetch_data_w_activity), ignore.case = TRUE)
names(fetch_data_w_activity) <- gsub("BodyBody", "Body", names(fetch_data_w_activity), ignore.case = TRUE)
names(fetch_data_w_activity) <- gsub("^f", "Freq", names(fetch_data_w_activity), ignore.case = TRUE)
names(fetch_data_w_activity) <- gsub("-freq()", "Freq", names(fetch_data_w_activity), ignore.case = TRUE)
names(fetch_data_w_activity) <- gsub("^t", "Time", names(fetch_data_w_activity), ignore.case = TRUE)

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
melt_data <- melt(fetch_data_w_activity, id = c("Subject", "Activity", "Activity_Label"))

#Tidaydata or rearrange using dcast and find mean
tidydata <- dcast(melt_data, Subject + Activity_Label ~ variable, mean)
#Write final data into a file
write.table (tidydata, "./Tidydata.txt", row.names=FALSE)


#Output Data Set

The output data Tidydata.txt is a a space-delimited value file. The header line contains the names of the variables. It contains the mean and standard deviation values of the data contained in the input files. The header is restructued in an understandable manner. 
   
