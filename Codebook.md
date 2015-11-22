# Codebook for Coursera "Gettting and Cleaning Data" Course Project
### Accompanying run_analysis.R script for preparing UCI HAR data into a tidy and summarized dataset

### Codebook describes the variables in the dataset and summaries used to preapare and analyze the data
*Rationale and stepwise description of the cleaning process is described in the README.md file*

## Source Data:
The Human Activity Recognition (HAR) experiment collected data from 30 volunteers (subjects) wearing a Samsung smart phone while performing a set of 6 defined activities.  The device's accelerometor (Acc) and gyroscope (Gyro) provided motion data that was sampled in time windows and processed. For each time window, 561 features were calculated from time and frequency domains.

## Data Dictionary

### Initial data sets

**activity_labels** 
6x2 data table, with added column names as below:
activity_code (int)	activity_desc (char)
1 			WALKING
2 			WALKING_UPSTAIRS
3 			WALKING_DOWNSTAIRS
4 			SITTING
5 			STANDING
6 			LAYING

**features**
561x2 data table, with added column names for "code" (integer 1-561) and "desc" (character descriptions).
The character descriptions are based on the following nomenclature.

There are **33** signals as follows:
*Note: "-XYZ" suffix indicates 3 variables, 1 for each axial direction (i.e., "-X", "-Y", and "-Z").
tBodyAcc-XYZ		(3)
tGravityAcc-XYZ		(3)
tBodyAccJerk-XYZ	(3)
tBodyGyro-XYZ		(3)
tBodyGyroJerk-XYZ	(3)
tBodyAccMag		(1)
tGravityAccMag		(1)
tBodyAccJerkMag		(1)
tBodyGyroMag		(1)
tBodyGyroJerkMag	(1)
fBodyAcc-XYZ		(3)
fBodyAccJerk-XYZ	(3)
fBodyGyro-XYZ		(3)
fBodyAccMag		(1)
fBodyAccJerkMag		(1)
fBodyGyroMag		(1)
fBodyGyroJerkMag	(1)

Prefix 't' denotes time domain signals. The acceleration (Acc) signal was separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ). The body linear acceleration and angular velocity were derived in time to obtain Jerk signals. Also the magnitude of these three-dimensional signals were calculated (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). A Fast Fourier Transform was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

For each of these signals, 17 variable estimates were derived including mean, standard deviation (std), median/min/max, IQR, and others. Additional vectors were obtained by averaging the signals on the angle variable. Only the mean and std variables will be of interest.

All features were normalized and bounded within [-1,1].  Therefore features have **NO UNITS**.

The features data table was used to identify features pertaining to mean value ("-mean()") and standard deviation ("-std()"), and to provide descriptive variable names to the data.

**subject_train** and **subject_test** (int)
train: 7352x1 vector of subject numbers corresponding to the 7352 observations in the training dataset (X_train) below.
test: 2947x1 vector of subject numbers corresponding to the 2947 observations in the test dataset (X_test) below.
*Note*
The 30 subjects (numbered 1-30) were randomly divided into training ("_train") and test ("_test") datasets:
Training (70%, or N=21): 1, 3, 5, 6, 7, 8, 11, 14, 15, 16, 17, 19, 21, 22, 23, 25, 26, 27, 28, 29, 30
Test (30%, or N=9): 2, 4, 9, 10, 12, 13, 18, 20, 24

**y_train** and **y_test**
train: 7352x1 vector of activity codes (1-6) corresponding to the 7352 observations in the training dataset (X_train) below.
test: 2947x1 vector of activity codes (1-6) corresponding to the 2947 observations in the test dataset (X_test) below.

**X_train** and **X_test** (numeric)
train: 7352x561 table of data.
test: 2947x561 table of data.

### Data Manipulations

**features_mean** and *features_std**
Subsets of features table above, both 33x2. Only feature variables containing ("-mean()") and standard deviation ("-std()") were extracted.
The first column, "code", is used to subset the data-containing "X" sets, and the second column "desc" is used to provide descriptive column names for the variables of interest.

**train_info**
7352x3 data table, with columns for subject (from subject_train), activity_code (from y_train), and a newly created column "set" with the string "training" in every row to identify the source of the data.

**train_mean** and **train_std**
Subsets of X_train pulling the 33 columns for mean and std (using indeces from features_mean and features_std code column above). Both are 7352x33.

**train_data**
Combined train_info, train_mean, and train_std, for 7352x69.

**test_info**, **test_mean**, **test_std**, and **test_data**
The same as the "train" tables above, except the row number is 2947, and the "set" column contains "test" to indicate the data source.
Final test_data is 2947x69.

**all_data**
Combined rows of train_data and test_data: 10299x69

**all_data2**
After setting key of data table all_data on activity_code, merged all_data with activity_labels to bring in activity descriptions (character) as an extra column. Data table is 10299x70. Column order was modified to bring the text activity_desc column from the last column to the 3rd column (following activity_code.
*Note: Although activity_code and activity_desc columns are redundant, I left both in to illustrate the history of how the data was combined. (And the instructions did not indicate that this interim dataset needs to be fully "tidy".)*
This represents the final *prepared* dataset.

## Final Tidy Dataset of Averages
The final output is a second, independent, tidy dataset containing the average of each variable by each subject and activity (30 subjects x 6 activities = 180 subject-activity pairs).
This dataset named "result" has dimension of 180 x 68, with columns as specified below:

**subject** (integer) 
values: 1-30

**activity_desc** (character) 
values: "WALKING" "WALKING_UPSTAIRS" "WALKING_DOWNSTAIRS" "SITTING" "STANDING" "LAYING"
*(final order is ascending = alphabetical)*

**Columns 3-68** (numeric)
values: calculated means by subject and activity description of the 66 "features" containing "-mean()" and "-std()" as described above.

**Order**
The final result dataset is ordered by subject, then activity description, both ascending.

This result was written to the text file "result.txt" for uploading.