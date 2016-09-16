#library(dplyr)
#library(Hmisc)

#Load the files

base_path<-"UCI Har Dataset"

activity_labels<-read.table(file.path(".",base_path,"activity_labels.txt"),sep=" ")
features<-read.table(file.path(".",base_path,"features.txt"))
train<-read.table(file.path(".",base_path,"train","X_train.txt"))
test<-read.table(file.path(".",base_path,"test","X_test.txt"))
test_activ<-read.table(file.path(".",base_path,"test","Y_test.txt"))
train_activ<-read.table(file.path(".",base_path,"train","Y_train.txt"))
train_subject<-read.table(file.path(".",base_path,"train","subject_train.txt"))
test_subject<-read.table(file.path(".",base_path,"test","subject_test.txt"))

#Merge the data from different files in one dataset
# Create the first column with the test and train activities
# add then the column with the test and train subject
# and to finish, add then the columns with the test and train observation results
merged<-cbind(rbind(test_activ,train_activ),
	rbind(test_subject,train_subject),
	rbind(test,train))

#Provide the names for the columns
#The two first are explicit, the other names come from the features file
names(merged)<-c("Activity","Subject",as.character(features[,2]))
#names(merged)[562]<-"Activity"
#names(merged)[563]<-"Subject"

#Give factor for Activities and Subject
#Factor levels for Activity come from the activity_labels file
merged$Activity<-as.factor(merged$Activity)
levels(merged$Activity)<-activity_labels[,2]
merged$Subject<-as.factor(merged$Subject)


#With dplyr
#mean_and_std<-grep("mean|std",names(merged),value=TRUE)
#tidy<-select(merged,mean_and_std,Activity)

#Without dplyr
#Subselect columnsname, select only those with mean or std, and do not forget Activity and Subject
col_subset<-grep("^Activity|^Subject|mean|std",names(merged))
tidy<-merged[col_subset]
#tidy<-cbind(merged$Activity,merged$Subject,tidy)

#Clean names
names(tidy)<-sub("Acc","Acceleration",names(tidy)) #Use full name
names(tidy)<-sub("^[t|f]","",names(tidy)) #Remove some leading letters
names(tidy)<-sub("-mean","Mean",names(tidy)) #Correct case for mean
names(tidy)<-sub("-std","StandardDeviation",names(tidy)) #Use full name for standard deviation
names(tidy)<-gsub("[\\(|\\)]","",names(tidy)) #Remove parenthesis
names(tidy)<-sub(".*\\$","",names(tidy)) #Remove the leading merged$...
names(tidy)<-sub("-","Axis",names(tidy)) #Replace the leading - before X, Y, Z with Axis
#grouped<-group_by(merged,Activity)
write.table(tidy,file="observations.txt",row.names=FALSE)
#Aggregate all variables on Activity and Subject
tidy_agg<-aggregate(tidy[3:81],list(tidy$Activity,tidy$Subject),mean)
names(tidy_agg)<-c("Activity","Subject",paste(names(tidy_agg[3:81]),"MeanPerGroup",sep=""))
write.table(tidy_agg,file="perSubjectActivityMean.txt",row.names=FALSE)

#perActivitySummary<-summarize(grouped,mean())
