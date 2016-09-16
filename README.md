# GettingAndCleaningData
Assignment for Data Science Getting and Cleaning Data course

## Introduction and purpose
In this assignment we are using the data from the "Human Activity Recognition Using Smartphones Data Set"
We need to create a tidy data set with the train and test data available
In addition to that, we also need another data set with the aggregated mean per subject and activity

##Available source data and files
The available source data comes from different files:
- activity_labels.txt : This is the "codebook" for labelling activities
- features.txt : This is the "codebook" for identifying the observation variables
- X, Y and subject files for train and test sets
-   X: This file contanis the observations
-   Y: This file contains the identified activity
-   subject: This file contains the subject observed
-   
##Approach (see comments in R script for more detail)

###Combination of data
We need to append the columns of the X, Y and subject files into a single data set.
This will provide a data set with the Activity, subject and observations
We need then to factorise the Activity to apply the activity labels to the factor variable levels
Afterwards, we need to apply the features file that contains the names of the observational variables

###Clean-up
We need to keep only the mean and standard deviation variables, we will grep the columns to retain only those applicable
Afterwards we do some housekeeping with the variable names so that they are more human readable
The dataset is dumped to file

###Aggregation
From the tidy data set, we will create an aggregation on activity and subject
The dataset is dumped to file

