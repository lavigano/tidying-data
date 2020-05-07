library(dplyr)

# copy the zipped file

DSUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
ds = 'C:/Users/laura.vigano/Documents/R e altro/Coursera Getting and Cleaning data/Project/ds_final.zip'
download.file(DSUrl, ds, method = 'curl')

#unzip 
unzip(ds) 


#read the .txt files

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


#1 .Merges the training and the test sets to create one data set.

#setto i dataset con le stesse variabili
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
S <- rbind(subject_train, subject_test)

XYS <- cbind(S, Y, X)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.


DataOk <- select(XYS, subject, code, contains("mean"), contains("std"))

#3. Uses descriptive activity names to name the activities in the data set

DataOk$code <- activities[DataOk$code, 2]

#4. Appropriately labels the data set with descriptive variable names.

names(DataOk)[2] = "activity"
names(DataOk)<-sub("Acc", "Accelerometer", names(DataOk))
names(DataOk)<-sub("Gyro", "Gyroscope", names(DataOk))
names(DataOk)<-sub("BodyBody", "Body", names(DataOk))
names(DataOk)<-sub("Mag", "Magnitude", names(DataOk))
names(DataOk)<-sub("^t", "Time", names(DataOk))
names(DataOk)<-sub("^f", "Frequency", names(DataOk))
names(DataOk)<-sub("tBody", "TimeBody", names(DataOk))
names(DataOk)<-sub("-mean()", "Mean", names(DataOk))
names(DataOk)<-sub("-std()", "STD", names(DataOk))
names(DataOk)<-sub("-freq()", "Frequency", names(DataOk))
names(DataOk)<-sub("angle", "Angle", names(DataOk))
names(DataOk)<-sub("gravity", "Gravity", names(DataOk))



#5.From the data set in step 4, creates a second, independent tidy data set
#  with the average of each variable for each activity and each subject.

DataOk2 <- DataOk %>%
           group_by(activity, subject) %>% summarize_all(mean)

#Check dataset

Final_colnames <- names(DataOk2)
Final_colnames


write.table(DataOk2, file="FinalData.txt", row.name=FALSE)





