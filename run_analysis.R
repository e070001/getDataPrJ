## run_analysis.R
## Coursera Data Science Course: Getting and Cleaning Data Project

# read the column names
data_cols <- read.table("features.txt", 
                        header=F, 
                        as.is=T, 
                        col.names=c("MeasureID", "MeasureName"))

## Step 1. Read Test Data
path_prefix <- "test"
fname_suffix <- "test"

# read the Y Test data file
fpath <- file.path(path_prefix paste0("y_", fname_suffix, ".txt"))      
y_data <- read.table(fpath, header=F, col.names=c("ActivityID"))

# read the subject data file
fpath <- file.path(path_prefix, paste0("subject_", fname_suffix, ".txt"))
subject_data <- read.table(fpath, header=F, col.names=c("SubjectID"))

# read the X test data file
fpath <- file.path(path_prefix, paste0("X_", fname_suffix, ".txt"))
data <- read.table(fpath, header=F, col.names=data_cols$MeasureName)

# names of subset columns required
subset_data_cols <- grep(".*mean\\(\\)|.*std\\(\\)", data_cols$MeasureName)

# subset the data (done early to save memory)
data <- data[,subset_data_cols]

# append the activity id and subject id columns
data$ActivityID <- y_data$ActivityID
data$SubjectID <- subject_data$SubjectID

# record the test data
test_data <- data


## Step 2. Read Training Data
path_prefix <- "train"
fname_suffix <- "train"

# read the Y Test data file
fpath <- file.path(path_prefix paste0("y_", fname_suffix, ".txt"))      
y_data <- read.table(fpath, header=F, col.names=c("ActivityID"))

# read the subject data file
fpath <- file.path(path_prefix, paste0("subject_", fname_suffix, ".txt"))
subject_data <- read.table(fpath, header=F, col.names=c("SubjectID"))

# read the X test data file
fpath <- file.path(path_prefix, paste0("X_", fname_suffix, ".txt"))
data <- read.table(fpath, header=F, col.names=data_cols$MeasureName)

# names of subset columns required
subset_data_cols <- grep(".*mean\\(\\)|.*std\\(\\)", data_cols$MeasureName)

# subset the data (done early to save memory)
data <- data[,subset_data_cols]

# append the activity id and subject id columns
data$ActivityID <- y_data$ActivityID
data$SubjectID <- subject_data$SubjectID

# record the test data
train_data <- data






print("STEP 1: Merging the training and the test sets to create one data set...")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                              header=F, 
                              as.is=T, 
                              col.names=c("ActivityID",
                                          "ActivityName"))
activity_labels$ActivityName <- as.factor(activity_labels$ActivityName)
data_labeled <- merge(data, activity_labels)
data_labeled
