require("data.table")
require("reshape2")

##activity labels dataset is loaded
activity_labels=read.table("./activity_labels.txt")

##Names of the data column names are loaded
features=read.table("./features.txt")
features=features[,2]
features_extracted=grepl("mean|std", features)

##x_test, y_test and subject_test data is loaded from the directory.
x_test=read.table("./test/X_test.txt")
y_test=read.table("./test/y_test.txt")
names(x_test)=features

subject_test=read.table("./test/subject_test.txt")

##Only mean and standard deviation is retrieved for each measurement
x_test=x_test[,features_extracted]

##activity labels are loaded
y_test[,2]=activity_labels$V2[y_test[,1]]
names(y_test)=c("Activity_ID", "Activity_Label")
names(subject_test)="subject"

test=cbind(as.data.table(subject_test), y_test, x_test)

##X_train, y_train and subject_train data is loaded from the directory.
X_train=read.table("./train/X_train.txt")
y_train=read.table("./train/y_train.txt")
subject_train=read.table("./train/subject_train.txt")

names(X_train)=features

##Only mean and standard deviation is retrieved for each measurement
X_train=X_train[,features_extracted]

##activity data is loaded
y_train[,2]=activity_labels$V2[y_train[,1]]
names(y_train)=c("Activity_ID", "Activity_Label")
names(subject_train)="subject"

train=cbind(as.data.table(subject_train), y_train, X_train)

##Merge the train and test data
data=rbind(test, train)

id_labels=c("subject", "Activity_ID", "Activity_Label")
data_labels=setdiff(colnames(data), id_labels)
meltData=melt(data, id = id_labels, measure.vars = data_labels)

##Apply mean function to dataset using dcast function
TidyData=dcast(meltData, subject + Activity_Label ~ variable, mean)
write.table(TidyData, file = "./tidy_data.txt")
