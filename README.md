==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 2.0
==================================================================
The experiments have been carried out with a group of 30 volunteers. Each person performed six activities 
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) 
on the waist. Using its embedded accelerometer and gyroscope, the experiment captures 3-axial(XYZ) linear acceleration 
and 3-axial angular velocity at a constant rate of 50Hz. 

For each record it is provided:
======================================
- Mean of all "Mean" and "standard deviation" of measured variables per activity and subjectID
- The measured variables are showing "Triaxial acceleration" and "Triaxial Angular velocity"
- Mean of all the above calculated variables in time and frequency
- The activity performed
- The subject ID

The dataset includes the following files:
=========================================
'README.txt'
'Code Book.pdf': Variables description
'experimentTidyDS.txt': The tidy dataset
'run_analysis.R': The R script for getting, cleaning data and producing tidy data set


Scripts:
=========================================
The comments provided in the run_analysis.R file help undrestand each line of code. However
to provide an overview of the strategies took for this project the following explanation is 
provided.

1- before running the script make sure that the source data files have been copied into a folder in your 
system and use the following line of code to set that folder as your working directory:

setwd("Address to to copied folder")

2- We read the training and test data sets using read.table function.
3- using the cbind() function we add two more columns into the datasets containing
 activity labels and subjectids.
4- We merge the training and test datasets using rbind() function
5- using make.names we ensure uniqueness of column names
6- We rename the column names in the data sets with the variable names in Feature.txt file
7- We identify variables(columns) containing "Mean" and "Standard deviation" and make a new data set
containing the identified variables
8- We replace activity ids with more descriptive activity names
9- We rename variable names to more descriptive names by:
	- Due long variable names and for readability we use CamelNaming
	- Replacing t with time
	- Replacing f with frequency
	- Replace abbreviation with descriptions
	- Getting rid of dots
10- We grouped data based on subject id and activity and calculated mean of all the available 
variables to produce the tidy data 
11- Finally we output the tidy data into a file named "experimentTidyDS.txt"
