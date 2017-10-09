ActLbls <- read.table("activity_labels.txt") 
ActLbls[,2] <- as.character(ActLbls[,2]) 
features <- read.table("features.txt") 
features[,2] <- as.character(features[,2]) 

# consider only data on mean and standard deviation 
ReqFeatures <- grep(".*mean.*|.*std.*", features[,2]) 
ReqFeatures.names <- features[ReqFeatures,2] 
ReqFeatures.names = gsub('-mean', 'Mean', ReqFeatures.names) 
ReqFeatures.names = gsub('-std', 'Std', ReqFeatures.names) 
ReqFeatures.names <- gsub('[-()]', '', ReqFeatures.names) 

#Read data from text files
Training <- read.table("train/X_train.txt")[ReqFeatures] 
TrainingAct <- read.table("train/Y_train.txt") 
TrainingSubj <- read.table("train/subject_train.txt") 
Training <- cbind(TrainingSubj, TrainingAct, Training) 

Test <- read.table("test/X_test.txt")[ReqFeatures] 
TestAct <- read.table("test/Y_test.txt") 
TestSubj <- read.table("test/subject_test.txt") 
Test <- cbind(TestSubj, TestAct, Test) 

# merge training and test data 
Total <- rbind(Training, Test) 
colnames(Total) <- c("Subject", "Activity", ReqFeatures.names) 

# turn activities & subjects into factors 
Total$Activity <- factor(Total$Activity, levels = ActLbls[,1], labels = ActLbls[,2]) 
Total$Subject <- as.factor(Total$Subject) 

Total.melted <- melt(Total, id = c("Subject", "Activity")) 
Total.mean <- dcast(Total.melted, Subject + Activity ~ variable, mean) 

write.table(Total.mean, "tidy.txt", row.names = FALSE) 