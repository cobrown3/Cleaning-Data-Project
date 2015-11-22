# Cleaning-Data-Project
Repo for Coursera Getting and Cleaning Data course project.

# README for Coursera "Gettting and Cleaning Data" Course Project
### Accompanying run_analysis.R script for preparing UCI HAR data into a tidy and summarized dataset

### README describes the rationale and stepwise description of the data extraction and analysis processes
*Codebook.md describes the variables in the dataset

## Source Data:
The Human Activity Recognition (HAR) experiment collected data from 30 volunteers (subjects) wearing a Samsung smart phone while performing a set of 6 defined activities.  The device's accelerometor (Acc) and gyroscope (Gyro) provided motion data that was sampled in time windows and processed. For each time window, 561 features were calculated from time and frequency domains.

## The analysis is broken up into a series of steps as described in detail below:
*Note these steps do not exactly follow those suggested in the project instructions.*

## STEP 1: Read in all the raw data
It was assumed that the script is running in a working directory with the UCI HAR data, including its subfolders for "train" and "test".
After calling library() for the package data.table, the function fread() was used to read in data tables. Aside from the benefit of very fast data reading, this package was chosen to allow convenient data manipulation using the data.table syntax.
Features, activity, as well as test and training subject, X, and Y data were read in.

## STEP 2: Extract mean/std data and combine with subject and activity data for each of the train and test datasets.
The features data table contained a column of 561 variable names.  These names were searched for strings containing "-mean()" or "-std()"; the searches returned tables of 33 rows for each of mean and std.

**The following manipulations were performed on both training and test data separately:**
1. A table was created with columns 1) subject numbers (from subject_train or subject_test) and 2) activity codes (from y_train or y_test). A third column named "set" with the label "train" (or "test") in every row was created to specify which dataset every row came from when the train and test datasets are merged (in a later step); this is so the data can be re-segregated in the same way if desired.
2. Columns containing mean and std features were extracted from the X_train (or X_test) dataset. These columns were named using the activity descriptions from the features dataset.
3. Complete datasets for train (or test) data were created by combining the subject/activity/set table (from above) with the tables containing the 33 mean and 33 std columns of features data.
The final train and test datasets therefore each had 69 columns.

## STEP 3: Combining train and test datasets
All of the rows from the train (7352 x 69) and test (2947 x 69) datasets were combined. The result was a data table containing 10299 observations.
This data table was then merged with the activity labels table, using the key "activity_code" which is a column in both tables. This now contains the activity code (integer 1-6) as well as the activity description (character).  This step **reorders the data** so was the last step in data preparation.

## STEP 4: Create new tidy dataset with calculated average of each variable for each activity/subject
After calling library() for the package dplyr, the final prepared dataset from STEP 3 above was grouped by subject and activity descriptor, and summarized with the mean() function. The result is a tidy dataset with 180 rows for each subject-activity pair and 68 columns: subject, activity (character string descriptions), and 66 features variables (33 mean and 33 std) for which the average by subject and activity were calculated. The data was ordered by subject and activity, both ascending.

*The final tidy dataset was chosen to be of the "short and wide" form as opposed to the "tall and narrow" form. The logic for this is that __each observation__ for a subject in an activity is from a single device and a single time window, from which all of the various data features were derived.*

This final tidy dataset was written to a .txt file. It can be read back into R using read.table with argument header=TRUE.
