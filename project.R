# load libraries that will be used
# load sqldf and use it to subset by *mean* and *std*
library(sqldf)
library(reshape2)

# defines the directory with the test and train sets
# used to make the code to load the files look cleaner
dirdata <- c("UCI HAR Dataset")

# load the files for the train dataset
# trainX - the training set
# trainY - the training labels
# trainSub - the train subjects

trainX <- read.table(paste(dirdata,"train/X_train.txt",sep="/"))
trainY <- read.table(paste(dirdata,"train/y_train.txt",sep="/"))
trainSub <- read.table(paste(dirdata,"train/subject_train.txt",sep="/"))

# load the files for the test dataset
# testX - the test set
# testY - the test labels
# testSub - the test subjects

testX <- read.table(paste(dirdata,"test/X_test.txt",sep="/"))
testY <- read.table(paste(dirdata,"test/y_test.txt",sep="/"))
testSub <- read.table(paste(dirdata,"test/subject_test.txt",sep="/"))

# load the activities labels

activities <- read.table(paste(dirdata,"activity_labels.txt",sep="/"))

# update the values with the correspondent activity name
trainY[, 1] <- activities[trainY[, 1], 2]
testY[, 1] <- activities[testY[, 1], 2]

# update the column name from V1 to "activity"
names(trainY) <- "activity"
names(testY) <- "activity"

# update the column name from V1 to "subject"
names(trainSub) <- "subject"
names(testSub) <- "subject"

# load the features list and get only the values with *mean* and *std*
features <- read.table(paste(dirdata,"features.txt",sep="/"))
features <- as.data.frame(features)
features <- sqldf("select * from features where V2 LIKE '%mean%' or V2 LIKE '%std%'")

# get the id for the rows we want to use
featShow <- features[, 1]

# subset the datasets to only show the values for those features
trainData <- trainX[, featShow]
testData <- testX[, featShow]

# update the names of features
names(trainData) <- features[, 2]
names(testData) <- features[, 2]

# combine the columns of X and Y and merge the data sets

trainAll <- cbind(trainSub,trainData,trainY)
testAll <- cbind(testSub,testData,testY)
dataAll <- rbind(trainAll,testAll)

# use descriptive names for the variables

dataColumns <- colnames(dataAll)
dataColumns <- gsub("[-(),]","", dataColumns) # remove the -(), symbols
dataColumns <- gsub("^t","time", dataColumns)
dataColumns <- gsub("^f","frequency", dataColumns)
dataColumns <- gsub("Acc","Accelerometer", dataColumns)
dataColumns <- gsub("Gyro","Gyroscope", dataColumns)
dataColumns <- gsub("Mag","Magnitude", dataColumns)
dataColumns <- gsub("mean","Mean", dataColumns)
dataColumns <- gsub("std","StandardDeviation", dataColumns)
dataColumns <- gsub("Freq","Frequency", dataColumns)
dataColumns <- gsub("anglet","angleTime", dataColumns)
dataColumns <- gsub("BodyBody","Body", dataColumns) # correct duplicated body string
names(dataAll) <- dataColumns

# transform subject and columns in factors to use with dcast
dataMelt <- melt(dataAll, id = c("subject","activity"), variable.name = "vars", value.name = "values")
# using dcast to generate the tidy data with the mean columns
dataTidy <- dcast(dataMelt, subject + activity ~ vars, mean)

write.table(dataTidy, "tidy.txt", quote = FALSE, row.names = FALSE)
