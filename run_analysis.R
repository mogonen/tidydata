if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")


#step 1
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
filtered <- grepl("mean|std", features)
labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

#step 2
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features
X_test = X_test[,filtered]

y_test[,2] = labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")

names(subject_test) = "subject"
test_data <- cbind(as.data.table(subject_test), y_test, X_test)


#step 3
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features


X_train = X_train[,filtered]

y_train[,2] = labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

train_data <- cbind(as.data.table(subject_train), y_train, X_train)

#step 4
cdata = rbind(test_data, train_data)
moltendata = melt(cdata, id = c("subject", "Activity_ID", "Activity_Label"), measure.vars = setdiff(colnames(cdata), id_labels))

tidy_data   = dcast(moltendata, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")