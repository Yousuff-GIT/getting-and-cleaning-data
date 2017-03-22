# Getting and Cleaning Data CodeBook
## Introduction
This file describes the variables, how the script works and the transformations that were made.

## Data Set

The data set used is the [UCI HAR Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and the original description is as follows.

> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

> The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Also, the original description of the variables in the data set is as follows.

> For each record in the dataset it is provided: 
> - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
> - Triaxial Angular velocity from the gyroscope. 
> - A 561-feature vector with time and frequency domain variables. 
> - Its activity label. 
> - An identifier of the subject who carried out the experiment.

## Variables

The variables used in the `run_analysis.R` script are:
- `dirdata`, only used to specifies the directory with the unzipped dataset.
- `trainX`, `trainY`, `trainSub`, `trainData`, variables used to store data for the train dataset.
- `testX`, `testY`, `testSub`, `testData`, variables used to store data for the test dataset.
- `activities`, variable with the activities lables.
- `features`, `featShow`, variables with the features name and the features that we want to subset (mean and std).
- `trainAll`, `testAll`, `dataAll`, variables used in the merge process.
- `dataColumns`, variable used to rename the original dataset variables to more descriptive names.
- `dataMelt`, variable used to _melt_ the dataset.
- `dataTidy`, variable used to create the tidy dataset.

The variables are also explained with comments inside the `run_analysis.R` script.

## Work and Transformations
The `run_analysis.R` script executes the following steps:
- read the train and test data and subjects into variables.
- read the activities labels into a variable.
- update the activities labels in the train and test dataset variables.
- update the column name for the activities and subject variables.
- read the features into a variable.
- use the library `sqldf` to select only the features that match the requirements of the project (features with meand and std in the name).
- get the id for the rows for the variables that we want to use.
- subset the train and test dataset.
- update the names of the features in the train and test datasets.
- use descriptive names for the activities.
- melt the dataset (tranform from wide format to single column)
- create and write the tidy dataset.

The transformations made in the original variables names are:
- `t` was changed to `time`
- `f` was changed to `frequency`
- `Acc` was changed to `Accelerometer`
- `Gyro` was changed to `Gyroscope`
- `Mag` was changed to `Magnitude`
- `mean` was changed to `Mean`
- `std` was changed to `StandardDeviation`
- `Freq` was changed to `Frequency`
- `anglet` was changed to `angleTime`
- `BodyBody` was corrected to `Body` because it appears to be an typo.

The `run_analysis.R` uses two packages, `sqldf` and `reshape2`  

To run this script, the "UCI HAR Dataset" directory must be in the same directory as the script.
