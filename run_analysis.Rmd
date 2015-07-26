---
title: "run_analysis"
output: word_document
---

##########################################
# 1 creat one dataset from train and test
##########################################
 

```{r}
subject_test <- read.table("~/tingfen/coursera/datascience/cleanData/UCI_HAR_Dataset/test/subject_test.txt", quote="\"", comment.char="")
X_test <- read.table("~/tingfen/coursera/datascience/cleanData/UCI_HAR_Dataset/test/X_test.txt", quote="\"", comment.char="")
y_test <- read.table("~/tingfen/coursera/datascience/cleanData/UCI_HAR_Dataset/test/y_test.txt", quote="\"", comment.char="")
##combine the three variables into one table
test=cbind(subject_test, y_test,X_test)
test$var=rep("test",2947)
##read each files in train
subject_train <- read.table("~/tingfen/coursera/datascience/cleanData/UCI_HAR_Dataset/train/subject_train.txt", quote="\"", comment.char="")
X_train <- read.table("~/tingfen/coursera/datascience/cleanData/UCI_HAR_Dataset/train/X_train.txt", quote="\"", comment.char="")
y_train <- read.table("~/tingfen/coursera/datascience/cleanData/UCI_HAR_Dataset/train/y_train.txt", quote="\"", comment.char="")
train=cbind(subject_train,y_train,X_train)
train$var=rep("train",7352)
##combine test and train sets
com=rbind(test,train)
## rename the column names
#get the column names
features <- read.table("~/tingfen/coursera/datascience/cleanData/UCI_HAR_Dataset/features.txt", quote="\"", comment.char="")
fnames=as.character(features$V2)
# rename the column names
names(com)=c("subjectID","activity",fnames,"dataset")
```
############################################
# 2 extract mean and STD for each measurement
############################################
```{r}
## build a vector containing all columnames with mean and STD
#mean
mn= com[,c("subjectID","activity","dataset", colnames(com)[grepl("mean\\(\\)",names(com))])]
#std
sd=com[,grep("std\\(\\)", names(com))]
# combine mean and std tables together
dat=cbind(mn,sd)
```
##########################################
# 4 label dataset
##########################################
```{r}
##get the column names for the measurement
col=names(dat)
col=col[-(1:3)]
##replace () by space
col1=sub("\\(\\)", "",col)
colnames(dat)=c("subjectID","activity","dataset",col1)
```
##########################################
# 5 create a tidy and independent dataset
##########################################
```{r}
##melt the data
dataMelt=melt(dat, id=c("subjectID","activity"), measure.vars = names(dat)[-(1:3)])
##make sure the value is numeric
dataMelt$value=as.numeric(dataMelt$value)
##summarize the measurement for subjectID and activity
dataAve=dcast(dataMelt, subjectID + activity ~ variable, mean)
##make the table tidy in tall way
dataAveMelt=melt(dataAve, id=c("subjectID", "activity"), measure.vars = names(dataAve)[-(1:2)])
write.table(dataAveMelt, "~/tingfen/coursera/datascience/cleanData/UCI_HAR_Dataset/dataset2.txt", row.names=F)

```


