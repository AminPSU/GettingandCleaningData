## Getting and Cleaning Data - Final Project

# "run_analysis.R" Overview

This script's goals are as followed step by step.

<b>Step 1:</b></br>
Reading all the data including both test and training dataset files: y_test.txt, subject_test.txt and X_test.txt.
Then combining these datasets to create a data frame in the form of subjects, labels, and so on.

<b>Step 2:</b></br>
Reading the features from features.txt and filtering them to only leave features that are either means or standard deviations. The goal for this step is to only include means and standard deviations of measurements, of which meanFreq() is neither. A new dataframe is then created that includes subjects, labels and the described features.

<b>Step 3:</b></br>
Read the activity labels from activity_labels.txt and replace them with their assosiated numbers.

<b>Step 4:</b></br>
Make a column list (Starting with "subjects" and "label")
Making the dataset more "Tidy" by removing all non-alphanumeric characters and converting the result to lowercase. Then, applying the now-good-columnnames to the data frame.

<b>Step 5:</b></br>
Create a new data frame by finding the mean for each combination of subject and label using aggregate() function.

<b>Final step:</b></br>
Write the new tidy set into a text file called TidyDataset.txt.
