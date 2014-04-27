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
fpath <- file.path(path_prefix, paste0("y_", fname_suffix, ".txt"))      
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
fpath <- file.path(path_prefix, paste0("y_", fname_suffix, ".txt"))      
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

## Step 2. Merging both training and test data sets with column names
data <- rbind(test_data, train_data)
cnames <- colnames(data)
cnames <- gsub("\\.+mean\\.+", cnames, replacement="Mean")
cnames <- gsub("\\.+std\\.+",  cnames, replacement="Std")
colnames(data) <- cnames

## Step 3. Add the activity names as another column
activity_labels <- read.table("activity_labels.txt", header=F, as.is=T, col.names=c("ActivityID", "ActivityName"))
activity_labels$ActivityName <- as.factor(activity_labels$ActivityName)
data_labeled <- merge(data, activity_labels) # Merged Labeled Data is obtained
merged_labeled_data <- data_labeled

## Step 4. Create a tidy data set that has the average of each variable for each activity and each subject.
library(reshape2)

# melt the dataset
id_vars = c("ActivityID", "ActivityName", "SubjectID")
measure_vars = setdiff(colnames(merged_labeled_data), id_vars)
melted_data <- melt(merged_labeled_data, id=id_vars, measure.vars=measure_vars)

# recast 
tidy_data <- dcast(melted_data, ActivityName + SubjectID ~ variable, mean)  

# save the tidy data set into a named file
fname <- "tidy_data_set.txt"
write.table(tidy_data, fname)






