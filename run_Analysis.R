#library(dplyr)
#library(Hmisc)

#Load the files
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",sep=" ")
features<-read.table("./UCI HAR Dataset/features.txt")
train<-read.table("./UCI Har Dataset/train/X_train.txt")
test<-read.table("./UCI Har Dataset/test/X_test.txt")
test_activ<-read.table("./UCI Har Dataset/test/Y_test.txt")
train_activ<-read.table("./UCI Har Dataset/train/Y_train.txt")
train_subject<-read.table("./UCI Har Dataset/train/subject_train.txt")
test_subject<-read.table("./UCI Har Dataset/test/subject_test.txt")

#Merge the data from different files in one dataset
merged<-cbind(rbind(test_activ,train_activ),rbind(test_subject,train_subject),rbind(test,train))

#Provide the names
names(merged)<-c("Activity","Subject",as.character(features[,2]))
#names(merged)[562]<-"Activity"
#names(merged)[563]<-"Subject"

#Give factor for Activities and Subject
print("Test and Train merged")
merged$Activity<-as.factor(merged$Activity)
levels(merged$Activity)<-activity_labels[,2]
merged$Subject<-as.factor(merged$Subject)


#With dplyr
#mean_and_std<-grep("mean|std",names(merged),value=TRUE)
#tidy<-select(merged,mean_and_std,Activity)

#Without dplyr
#Subselect columnsname
mean_and_std<-grep("mean|std",names(merged))
tidy<-merged[mean_and_std]
tidy<-cbind(merged$Activity,merged$Subject,tidy)

#Clean names
names(tidy)<-sub("Acc","Acceleration",names(tidy)) #Use full name
names(tidy)<-sub("^[t|f]","",names(tidy)) #Remove some leading letters
names(tidy)<-sub("-mean","Mean",names(tidy)) #Correct case for mean
names(tidy)<-sub("-std","StandardDeviation",names(tidy)) #Use full name for standard deviation
names(tidy)<-gsub("[\\(|\\)]","",names(tidy)) #Remove parenthesis
names(tidy)<-sub(".*\\$","",names(tidy)) #Remove the leading merged$...
#grouped<-group_by(merged,Activity)

#Aggregate all variables on Activity and Subject
tidy_agg<-aggregate(tidy[3:81],list(tidy$Activity,tidy$Subject),mean)
names(tidy_agg)<-c("Activity","Subject",paste(names(tidy_agg[3:81]),"MeanPerGroup"))

#perActivitySummary<-summarize(grouped,mean())
