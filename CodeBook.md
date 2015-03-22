#CodeBook

## Data Sources

The original data set used in this project is downloaded via the 'run_analysis' script.

This data provides the following information:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

This data is split accross the following files for both training and test data sets:

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

- 'test/subject_test.txt': As above. 

## Data Cleansing

The raw datasets are loaded directly from the files listed above, 
on the assumption that the datasets are contained within a `UCI HAR Dataset` directory within the working directory containing the
`run_analysis` R script.

1. Firstly both test and train data sets are joined by row to give three combined data sets. These are stored in the variables:
1.1 `x.data`: Combined rows from X_train and X_test data files.
1.2 `y.data`: Combined rows from Y_train and Y_test data files.
1.3 `subject.data`: Combined rows from subject_train and subject_test data files.
2. For the `x.data` table, only those features which contain Standard Deviation or Mean data are retained for further processing.
2.1 The regular expression `"(std|mean)+"` is used to reject columns which do not match this pattern.
2.2 Feature names for the `x.data` set are cleaned to provide more human readable format.
3. For the 'y.data` table:
3.1 Each row containing an Activity Id is joined with the Activity Labels file to include the Activity Label in the table.
3.2 Columns in the `y.data` table are renamed to better reflect the contents of the two columns: ActivityId & ActivityLabel
4. The `subject.data` file has a new columne name applied _Subject_ to better reflect the contents of the column.
5. All three pre-processed data sets are combined by column: ```combined.data <- bind_cols(x.data, y.data, subject.data)```
6. The `combined.data` table is reconfigured to perform the following transformations:
6.1 Group the data by ActivityName and Subject
6.2 For each group, summarize to produce means for each feature column
6.3 Finally, trim off the ActivityId column as this is redundant when ActivityName is already included

## Summary of Tidied Data

The following rules are applied to tidy the Feature column names:

* `t` at start of line, replaced with `Time`
* `f` at start of line, replaced with `Frequency`
* `()`, `-`, replaced with empty string
* `mean`, replaced with `Mean`
* `std`, replaced with `Std`

The following table describes the contents of the tidied data set:

| Column            | Description                                                                  |   |
|-------------------|------------------------------------------------------------------------------|---|
| ActivtyName       | Activity name as mapped from ActivtyId to Label using `activity_labels.txt`  |   |
| Subject           | Subject value                                                                |   |
| TimeBodyAccMeanX  | Average value from combined test and training data sets                      |   |
| TimeBodyAccMeanY  | Average value from combined test and training data sets                      |   |
| TimeBodyAccMeanZ  | ...                                                                          |   |
|