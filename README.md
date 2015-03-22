#Getting And Cleaning Data Course Project - Coursera


##This repository contains:

* README.md: This file gives the instructions on how to run the 'run_anlysis.R' script for this Course Project.
* CodeBook.md: This file provides information about the raw and tidy data sets used in the project and the transformation process.
* run_analysis.R: An R script to perform the transformation on the raw dataset.

##Setup

There is no steps required before the running of the 'run_analysis.R' script as this script performs the following:

1. Checks to make sure the "dplyr" and "downloader" R packages are installed, as these are required. 
    - If installed it will load them. 
    - If not installed the packages will be installed and then loaded.

2. It will download the zipped data file from: [UCI HAR Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

3. It will Unzip the file into the working directory containing `run_analysis.R`

4. This will create a new sub-directory called _UCI HAR Dataset_

5. It will remove the UCI HAR Dataset.zip as it is no longer needed.

