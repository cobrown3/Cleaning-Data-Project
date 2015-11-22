#run_analysis.R
#Will run if data is in working directory (and sub-folders)
#Note: STEPS do not exactly correspond to those in the project instructions.

#STEP 1: Read in all the raw data into data tables using fread
library(data.table,quietly=TRUE)

features <- fread("features.txt")
     names(features) <- c("code","desc")
activity_labels <- fread("activity_labels.txt")
     names(activity_labels) <- c("activity_code","activity_desc")

if (!exists("subject_test")) {subject_test <- fread("test/subject_test.txt")}
X_test <- fread("test/X_test.txt")
y_test <- fread("test/y_test.txt")

if (!exists("subject_train")) {subject_train <- fread("train/subject_train.txt")}
X_train <- fread("train/X_train.txt")
y_train <- fread("train/y_train.txt")

#STEP 2: Extract Mean/SD data and combine with subject and activity data
          #for each of train and test datasets

features_mean <- features[grep("-mean()", features$desc, fixed = TRUE)]
features_std <- features[grep("-std()", features$desc, fixed = TRUE)]
features_all <- c(features_mean$desc, features_std$desc)

#training data
train_info <- cbind(subject_train, y_train, "training")
     colnames(train_info) <- c("subject","activity_code","set")
     #"set" column so that when merged with test data source can be distinguished

train_mean <- X_train[, features_mean$code, with=FALSE]
     colnames(train_mean) <- features_mean$desc
     
train_std <- X_train[, features_std$code, with=FALSE]
     colnames(train_std) <- features_std$desc

train_data <- cbind(train_info, train_mean, train_std)

#test data
test_info <- cbind(subject_test, y_test, "test")
     colnames(test_info) <- c("subject","activity_code","set")
     #"set" column so that when merged with training data source can be distinguished
     
test_mean <- X_test[, features_mean$code, with=FALSE]
     colnames(test_mean) <- features_mean$desc

test_std <- X_test[, features_std$code, with=FALSE]
     colnames(test_std) <- features_std$desc

test_data <- cbind(test_info, test_mean, test_std)
     
#STEP 3: Combined test and train datasets
all_data <- rbind(train_data, test_data)

#add activity description; setkey and merge
setkey(all_data, activity_code)
all_data2 <- all_data[activity_labels]
     setcolorder(all_data2, c(1:2,70,3:69))
     
#STEP 4: Create new tidy dataset with average of each variable 
#for each activity and each subject (180 subject-activity pairs).

#Use dplyr package to get mean of each mean and std column into a new table
library(dplyr, quietly = TRUE)
result <- all_data2 %>% group_by(subject, activity_desc) %>%
        summarize_each (funs(mean), contains("mean()"), contains("std()")) %>%
        setorder(subject, activity_desc)

#This is the data set to be uploaded as a text file.
write.table(result, file = "result.txt", row.name=FALSE)

#Code for reading back into R: read.table(file_path, header=TRUE)