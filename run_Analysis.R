library(dplyr)
library(Hmisc)


activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",sep=" ")
features<-read.table("./UCI HAR Dataset/features.txt")
train<-read.table("./UCI Har Dataset/train/X_train.txt")
test<-read.table("./UCI Har Dataset/test/X_test.txt")
test_activ<-read.table("./UCI Har Dataset/test/Y_test.txt")
train_activ<-read.table("./UCI Har Dataset/train/Y_train.txt")
names(test_activ)<-c("Activity")
names(test)<-features[,2]
test<-cbind(test,test_activ)
train<-cbind(train,train_activ)

merged<-rbind(test,train)

Print "merged"
merged$Activity<-as.factor(merged$Activity)
levels(merged$Activity)<-activity_labels[,2]

mean_and_std<-grep("mean|std",names(merged),value=TRUE)

merged<-select(merged,mean_and_std,Activity)

#grouped<-group_by(merged,Activity)

#perActivitySummary<-summarize(grouped,mean())
