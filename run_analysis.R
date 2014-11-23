#Load required packages
packages <- c("data.table","dplyr","utils")
sapply(packages,require,character.only = TRUE)

#Download database and extract data
source("GetData.R")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "dataset.zip"
download_zip(url,zipfile)


#Read the files
path <- "UCI HAR Dataset"

#Read the subject files
SubjectTest <- fread(input = file.path(path,"test","subject_test.txt"))
SubjectTrain <- fread(input = file.path(path,"train","subject_train.txt"))

#Read the activity files
ActivityTest <- fread(input = file.path(path,"test","y_test.txt"))
ActivityTrain <- fread(input = file.path(path,"train","y_train.txt"))

#Read the training files
TrainingTest <- read.table(file = file.path(path,"test","X_test.txt"),
                        header = FALSE)
TrainingTrain <- read.table(file = file.path(path,"train","X_train.txt"),
                           header = FALSE)
TrainingTest <- data.table(TrainingTest)
TrainingTrain <- data.table(TrainingTrain)

#Read the activity labels
ActivityLabels <- fread(input = file.path(path,"activity_labels.txt"))
setnames(ActivityLabels,1,"ActivityID")
setnames(ActivityLabels,2,"ActivityName")

#Read the features file
Features <- fread(input = file.path(path,"features.txt"))
setnames(Features,1,"FeatureID")
setnames(Features,2,"FeatureName")

#Merge the datasets
Subject <- rbind(SubjectTest,SubjectTrain)
Activity <- rbind(ActivityTest,ActivityTrain)
Training <- rbind(TrainingTest,TrainingTrain)
Data <- cbind(Subject,Activity,Training)

#Set descriptive names
setnames(Data,old = 1,new = "Subject")
setnames(Data,old = 2,new = "ActivityID")

#Order Data by Subject and Activity
setkey(Data,Subject,ActivityID)
Data <- merge(x = ActivityLabels,y = Data,by = "ActivityID",all=TRUE)
Data <- select(Data,-1)
setkey(Data,Subject,ActivityName)