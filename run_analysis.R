
# Function to load the required packages, if the are already installed on the local machine.
# Function to install required packages, if the required packages are not on the local machine and then load these packages.
install_and_load <- function (package1,package2)  {
    
    # convert arguments to vector
    packages <- c(package1,package2)
    
    # start loop to determine if each package is installed
    for(package in packages){
        
        # if package is installed locally, load
        if(package %in% rownames(installed.packages()))
        do.call('library', list(package))
        
        # if package is not installed locally, download, then load
        else {
            install.packages(package)
            do.call("library", list(package))
        }
    }
}

# Calling function to check for the availablity of the required R Packages.
install_and_load("dplyr","downloader")

# Dowloading raw data
download("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", dest="UCI HAR Dataset.zip", mode="curl")

# Unzipping raw data
unzip ("UCI HAR Dataset.zip", exdir = "./")

# Removing Zip file aftr the raw data is extracted into directory.
unlink ("UCI HAR Dataset.zip")

# This function assumes the successful download and unzipping of the UCI HAR Dataset and that this download and unzipping created
# a sub-directory containing all Samsung instrumentation data exists within the same directory as this source file.
run_analysis <- function(write.file=FALSE, file.name='TidyDatasetOutput.csv') {
    # Fuction accepts two optional parameters, these are:
    # (Option : Default value)
    # write.file : FALSE
    # file.name : 'TidyDatasetOutput.csv'
    # Output can be written to file or to a dataset, this is based on how the user executes the run_analysis funtion.
    
  data.dir <- "./UCI HAR Dataset/"
  features.file <- paste(data.dir, "features.txt", sep="")
  activity.file <- paste(data.dir, "activity_labels.txt", sep="")
  
  # Load raw data sets for training and test
  test.data <- read.datasets(data.dir, "test")
  train.data <- read.datasets(data.dir, "train")
  # Load sub-set of desired features (std|mean) and all activity labels
  features <- get.features(features.file)
  activity.labels <- get.activities(activity.file)
  
  # Combine rows for test and training X, Y and Subject results
  x.data <- bind_rows(test.data$X, train.data$X)
  y.data <- bind_rows(test.data$Y, train.data$Y)
  subject.data <- bind_rows(test.data$Subject, train.data$Subject)
  
  # Select only desired feature columns from x.data
  x.data <- x.data %>% select(num_range("V", features$FeatureLabel))
  names(x.data) <- features$FeatureName
  x.data <- clean.featureNames(x.data)
  
  # Update the y.data table to use correct activity names
  names(y.data) <- c("ActivityId")
  y.data <- inner_join(y.data, activity.labels, by="ActivityId")
  
  # Update the subject.data
  names(subject.data) <- c("Subject")
  
  # Combine final data set and return summary of mean values by activity and subject
  combined.data <- bind_cols(x.data, y.data, subject.data)
  tidy.data <- summarise_each(group_by(combined.data, ActivityName, Subject), funs(mean))
  
  if(write.file){
      write.table(tidy.data[,1:81], file=file.name, sep = ',', row.names=F)
  }
  else{
      return(tidy.data[,1:81])
  }
  
}

# Retrieve only the desired feature values (containing mean or std)
get.features <- function(features.file) {
  features <- tbl_df(read.table(features.file, 
                                header = FALSE, 
                                col.names = c("FeatureLabel", "FeatureName")))
  result <- features %>% filter(grepl("(std|mean)+", FeatureName))
  return (result)
}

get.activities <- function(activity.file) {
  activity.labels <- tbl_df(read.table(activity.file, 
                                       header = FALSE, 
                                       col.names = c("ActivityId", "ActivityName")))
  return(activity.labels)
}

# Clean feature labels to make them tidier and readable.
clean.featureNames <- function(data) {
  names(data) <- gsub('^t', 'Time', names(data))
  names(data) <- gsub('^f', 'Frequency', names(data))
  names(data) <- gsub('\\(', '', names(data))
  names(data) <- gsub('\\)', '', names(data))
  names(data) <- gsub('-', '', names(data))
  names(data) <- gsub('mean', 'Mean', names(data))
  names(data) <- gsub('std', 'Std', names(data))
  return(data)
}

# Function to read in each raw dataset (either train or test)
# Returns a list labeled X, Y, Subject for each  corresponding file 
# within the specified sub-directory.
read.datasets <- function(data.dir, type) {
  if (type != "test" && type != "train") {
    stop("Dataset is invalid. Valid datasets are 'training' or 'test' only.")
  }
  
  x.filename <- paste(data.dir, type, "/X_", type, ".txt", sep="")
  y.filename <- paste(data.dir, type, "/Y_", type, ".txt", sep="")
  subject.filename <- paste(data.dir, type, "/subject_", type, ".txt", sep="")
  
  x.data <- tbl_df(read.table(x.filename))
  y.data <- tbl_df(read.table(y.filename))
  subject.data <- tbl_df(read.table(subject.filename))
  return (list("X" = x.data, "Y" = y.data, "Subject" = subject.data))
}