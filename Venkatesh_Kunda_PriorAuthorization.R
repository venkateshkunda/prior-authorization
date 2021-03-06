####  Prior authentication prediction for prescribed medication  ###


### Coding ###

rm(list=ls(all=TRUE))
getwd()
Data<-read.csv("PriorAuth_Data.csv",header=T)
str(Data)

####Making the unique date format in the data#####

a <- as.Date(Data$TransDate,format="%m/%d/%Y") # Produces NA when format is not "%m/%d/%Y"
b <- as.Date(Data$TransDate,format="%m-%d-%Y") # Produces NA when format is not "%d-%m-%Y"
a[is.na(a)] <- b[!is.na(b)] # Combine both while keeping their ranks
Data$TransDate <- a # Put it back in your dataframe
Data$TransDate
Data


#To check whether Missing are cohesed while transforming Date#

sum(is.na(Data$TransDate))

#Removing the Attribute User ID and TransDate#

Data<-subset(Data,select=-c(UserID))
Data<-subset(Data,select=-c(TransDate))
names(Data)

########Finding the frequencies########

Drug<-as.data.frame(table(Data$Drug,Data$Target))
DrugSubClass<-as.data.frame(table(Data$DrugSubClass,Data$Target))
DrugClass<-as.data.frame(table(Data$DrugClass,Data$Target))
Drug_Chemical_Name<-as.data.frame(table(Data$Drug_Chemical_Name,Data$Target))
GPI<-as.data.frame(table(Data$GPI,Data$Target))
NDC<-as.data.frame(table(Data$NDC,Data$Target))
DrugGroup<-as.data.frame(table(Data$DrugGroup,Data$Target))
DoctorID<-as.data.frame(table(Data$DoctorID,Data$Target))
RxGroupId<-as.data.frame(table(Data$RxGroupId,Data$Target))
Bin<-as.data.frame(table(Data$Bin,Data$Target))
PCN<-as.data.frame(table(Data$PCN,Data$Target))
State<-as.data.frame(table(Data$State,Data$Target))


#Reshaping Data#

library(reshape)

Drug_Freq<-cast(Drug,Var1~Var2)
DrugSubClass_Freq<-cast(DrugSubClass,Var1~Var2)
DrugClass_Freq<-cast(DrugClass,Var1~Var2)
Drug_Chemical_Name_Freq<-cast(Drug_Chemical_Name,Var1~Var2)
GPI_Freq<-cast(GPI,Var1~Var2)
NDC_Freq<-cast(NDC,Var1~Var2)
DrugGroup_Freq<-cast(DrugGroup,Var1~Var2)
DoctorID_Freq<-cast(DoctorID,Var1~Var2)
RxGroupId_Freq<-cast(RxGroupId,Var1~Var2)
Bin_Freq<-cast(Bin,Var1~Var2)
PCN_Freq<-cast(PCN,Var1~Var2)
State_Freq<-cast(State,Var1~Var2)

##Forming Clusters to reduce the number of levels in the data##

names(Data)

C1<- 0
for (i in 1:15) {
  set.seed(123)
  C1[i] <- sum(kmeans(Drug_Freq,centers=i)$withinss)
}

plot(1:15,C1, 
     type="b", 
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")


C2<- 0
for (i in 1:15) {
  set.seed(123)
  C2[i] <- sum(kmeans(DrugSubClass_Freq,centers=i)$withinss)
}

plot(C2, 
          type="b",
          xlab="Number of Clusters",
          ylab="Within groups sum of squares")

C3<- 0
for (i in 1:15) {
  set.seed(123)
  C3[i] <- sum(kmeans(DrugClass_Freq,centers=i)$withinss)
}

plot(C3, 
     type="b", 
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")

C4<- 0
for (i in 1:15) {
  set.seed(123)
  C4[i] <- sum(kmeans(Drug_Chemical_Name_Freq,centers=i)$withinss)
}

plot(C4, 
     type="b", 
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")

C5<- 0
for (i in 1:15) {
  set.seed(123)
  C5[i] <- sum(kmeans(GPI_Freq,centers=i)$withinss)
}

plot(C5, 
     type="b", 
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")

C6<- 0
for (i in 1:15) {
  set.seed(123)
 C6[i] <- sum(kmeans(NDC_Freq,centers=i)$withinss)
}

plot(C6, 
     type="b", 
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")

C7<- 0
for (i in 1:15) {
  set.seed(123)
  C7[i] <- sum(kmeans(DrugGroup_Freq,centers=i)$withinss)
}

plot(C7, 
     type="b", 
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")

C8<- 0
for (i in 1:15) {
  set.seed(123)
  C8[i] <- sum(kmeans(DoctorID_Freq,centers=i)$withinss)
}

plot(C8, 
     type="b", 
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")

C9<- 0
for (i in 1:15) {
  set.seed(123)
  C9[i] <- sum(kmeans(RxGroupId_Freq,centers=i)$withinss)
}

plot(C9, 
     type="b", 
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")

C10<- 0
for (i in 1:15) {
  set.seed(123)
  C10[i] <- sum(kmeans(Bin_Freq,centers=i)$withinss)
}

plot(C10, 
     type="b", 
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")

C11<- 0
for (i in 1:15) {
  set.seed(123)
  C11[i] <- sum(kmeans(PCN_Freq,centers=i)$withinss)
}

plot(C11, 
     type="b", 
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")

C12<- 0
for (i in 1:15) {
  set.seed(123)
  C12[i] <- sum(kmeans(State_Freq,centers=i)$withinss)
}

plot(C12, 
     type="b", 
     xlab="Number of Clusters",
     ylab="Within groups sum of squares")



##Found number of clusters to be formed on each attribute using elbow curve,
#Merging Frequencies and Clusters##

set.seed(123)
Merge1 <- kmeans(Drug_Freq,12)
set.seed(123)
Merge2 <- kmeans(DrugSubClass_Freq,10)
set.seed(123)
Merge3 <- kmeans(DrugClass_Freq,11)
set.seed(123)
Merge4 <- kmeans(Drug_Chemical_Name_Freq,10)
set.seed(123)
Merge5 <- kmeans(GPI_Freq,14)
set.seed(123)
Merge6 <- kmeans(NDC_Freq,13)
set.seed(123)
Merge7 <- kmeans(DrugGroup_Freq,07)
set.seed(123)
Merge8 <- kmeans(DoctorID_Freq,15)
set.seed(123)
Merge9 <- kmeans(RxGroupId_Freq,10)
set.seed(123)
Merge10 <- kmeans(Bin_Freq,8)
set.seed(123)
Merge11 <- kmeans(PCN_Freq,6)
set.seed(123)
Merge12 <- kmeans(State_Freq,6)

##Appending Clusters to orginal Data##


Append1<-as.data.frame(cbind(Drug_Freq,c1=Merge1$cluster))
Drug.Final<-as.data.frame(Append1[,-c(2,3)])
Drug.Final<-rename(Drug.Final,c("Var1"="Drug"))


Append2<-as.data.frame(cbind(DrugSubClass_Freq,c2=Merge2$cluster))
DrugSubClass.Final<-as.data.frame(Append2[,-c(2,3)])
DrugSubClass.Final<-rename(DrugSubClass.Final,c("Var1"="DrugSubClass"))

Append3<-as.data.frame(cbind(DrugClass_Freq,c3=Merge3$cluster))
Drugclass.Final<-as.data.frame(Append3[,-c(2,3)])
Drugclass.Final<-rename(Drugclass.Final,c("Var1"="DrugClass"))

Append4<-as.data.frame(cbind(Drug_Chemical_Name_Freq,c4=Merge4$cluster))
Drug_Chemical_Name.Final<-as.data.frame(Append4[,-c(2,3)])
Drug_Chemical_Name.Final<-rename(Drug_Chemical_Name.Final,c("Var1"="Drug_Chemical_Name"))

Append5<-as.data.frame(cbind(GPI_Freq,c5=Merge5$cluster))
GPI.Final<-as.data.frame(Append5[,-c(2,3)])
GPI.Final<-rename(GPI.Final,c("Var1"="GPI"))

Append6<-as.data.frame(cbind(NDC_Freq,c6=Merge6$cluster))
NDC.Final<-as.data.frame(Append6[,-c(2,3)])
NDC.Final<-rename(NDC.Final,c("Var1"="NDC"))

Append7<-as.data.frame(cbind(DrugGroup_Freq,c7=Merge7$cluster))
DrugGroup.Final<-as.data.frame(Append7[,-c(2,3)])
DrugGroup.Final<-rename(DrugGroup.Final,c("Var1"="DrugGroup"))

Append8<-as.data.frame(cbind(DoctorID_Freq,c8=Merge8$cluster))
DoctorID.Final<-as.data.frame(Append8[,-c(2,3)])
DoctorID.Final<-rename(DoctorID.Final,c("Var1"="DoctorID"))


Append9<-as.data.frame(cbind(RxGroupId_Freq,c9=Merge9$cluster))
RxGroupId.Final<-as.data.frame(Append9[,-c(2,3)])
RxGroupId.Final<-rename(RxGroupId.Final,c("Var1"="RxGroupId"))

Append10<-as.data.frame(cbind(Bin_Freq,c10=Merge10$cluster))
Bin.Final<-as.data.frame(Append10[,-c(2,3)])
Bin.Final<-rename(Bin.Final,c("Var1"="Bin"))

Append11<-as.data.frame(cbind(PCN_Freq,c11=Merge11$cluster))
PCN.Final<-as.data.frame(Append11[,-c(2,3)])
PCN.Final<-rename(PCN.Final,c("Var1"="PCN"))

Append12<-as.data.frame(cbind(State_Freq,c12=Merge12$cluster))
State.Final<-as.data.frame(Append12[,-c(2,3)])
State.Final<-rename(State.Final,c("Var1"="State"))


##Building Models###


Data.Merge<-merge(x=Data,y=Drug.Final,by.x="Drug",by.y="Drug",all.x="TRUE")
Data.Merge<-merge(x=Data.Merge,y=DrugSubClass.Final,by.x="DrugSubClass",by.y="DrugSubClass",all.x="TRUE")
Data.Merge<-merge(x=Data.Merge,y=Drugclass.Final,by.x="DrugClass",by.y="DrugClass",all.x="TRUE")
Data.Merge<-merge(x=Data.Merge,y=Drug_Chemical_Name.Final,by.x="Drug_Chemical_Name",by.y="Drug_Chemical_Name",all.x="TRUE")
Data.Merge<-merge(x=Data.Merge,y=GPI.Final,by.x="GPI",by.y="GPI",all.x="TRUE")
Data.Merge<-merge(x=Data.Merge,y=NDC.Final,by.x="NDC",by.y="NDC",all.x="TRUE")
Data.Merge<-merge(x=Data.Merge,y=DrugGroup.Final,by.x="DrugGroup",by.y="DrugGroup",all.x="TRUE")
Data.Merge<-merge(x=Data.Merge,y=DoctorID.Final,by.x="DoctorID",by.y="DoctorID",all.x="TRUE")
Data.Merge<-merge(x=Data.Merge,y=RxGroupId.Final,by.x="RxGroupId",by.y="RxGroupId",all.x="TRUE")
Data.Merge<-merge(x=Data.Merge,y=Bin.Final,by.x="Bin",by.y="Bin",all.x="TRUE")
Data.Merge<-merge(x=Data.Merge,y=PCN.Final,by.x="PCN",by.y="PCN",all.x="TRUE")
Data.Merge<-merge(x=Data.Merge,y=State.Final,by.x="State",by.y="State",all.x="TRUE")


Data.Merge<-subset(Data.Merge,select=-c(Drug,DrugSubClass,DrugClass,Drug_Chemical_Name,GPI,
                                        NDC,DrugGroup,DoctorID,RxGroupId,Bin,PCN,State))

summary(Data.Merge)
str(Data.Merge)

   ##Finding Correlation##

Data.Merge_N<-subset(Data.Merge,select =-c(Target))
c<-cor(Data.Merge_N,use="complete.obs",method="pearson")
cor<-as.table(sort(c))
head(cor)
tail(cor)

###############################

names(Data.Merge)
names(Data)
str(Data.Merge)

Data.Merge_N<-subset(Data.Merge,select=-c(Target))
str(Data.Merge_N)
cor(Data.Merge_N,method="pearson")

####Dividing Training & Testing Data ##

#Split the data into train and test data sets (70:30 ratio)
rows = seq(1,nrow(Data.Merge),1)
set.seed(123)
trainRows = sample(rows,(70*nrow(Data.Merge))/100)
train = Data.Merge[trainRows,] 
test = Data.Merge[-trainRows,]

#Converting to Factor Attributes#
train.cart<-data.frame(apply(train,2,function(x){as.factor(x)}))


#Converting to Factor Attributes#
test.cart<-data.frame(apply(test,2,function(x){as.factor(x)}))

##Decision Trees using C50##

library(C50)
dtC50= C5.0(Target~ .,
            data = train.cart,
            rules=TRUE)

help(C5.0)

C5imp(dtC50, pct=TRUE)

dtC50$rules

summary(dtC50)

# predict C5.0 model on test data
Predict_C50 <- predict.C5.0(object = dtC50, newdata = test.cart)
Predict_C50
table(Predict_C50)

# write rules into text file
write(capture.output(summary(dtC50)), "Model_C50_Rules.txt")

# confusion matrix for prediction#
#using dataset "test" to have correct formation of cofusion matrix#

CM_C50 <- table(test$Target, Predict_C50)
CM_C50

Accuracy_C50 <- sum(diag(CM_C50))/sum(CM_C50)*100
Accuracy_C50

Recall_C50 <- CM_C50[2,2]/(CM_C50[2,1]+CM_C50[2,2])*100
Recall_C50

Precision_C50 <- CM_C50[2,2]/(CM_C50[1,2]+CM_C50[2,2])*100
Precision_C50

###########################################################################################
##Random Forest##

library(randomForest)
set.seed(123)
rf <- randomForest(Target ~ ., data=train.cart, keep.forest=TRUE, ntree=30)

round(importance(rf), 2)

# test predict using model#

Predict_RF <- predict(object = rf, newdata = test.cart, type = "response", 
                      norm.votes = TRUE)

#using dataset "test" to have correct formation of cofusion matrix#

CM_RF <- table(test$Target, Predict_RF)
CM_RF

Accuracy_RF <- sum(diag(CM_RF))/sum(CM_RF)*100
Accuracy_RF

Recall_RF <- ((CM_RF[2,2])/(CM_RF[2,2]+CM_RF[2,1])*100)
Recall_RF

Precision_RF <- ((CM_RF[2,2])/(CM_RF[2,2]+CM_RF[1,2])*100)
Precision_RF

##################################################################################
## Naive Bayes##

library(e1071)
model <- naiveBayes(train.cart$Target~., data = train.cart)
model
Predict_NB = predict(model, test.cart)
Predict_NB
###Confusion Matrix####
#using dataset "test" to have correct formation of cofusion matrix#

CM_NB <- table(test$Target,Predict_NB)
CM_NB


Accuracy_NB <- sum(diag(CM_NB))/sum(CM_NB)*100
Accuracy_NB

Recall_NB <- ((CM_NB[2,2])/(CM_NB[2,2]+CM_NB[2,1])*100)
Recall_NB

Precision_NB <- ((CM_NB[2,2])/(CM_NB[2,2]+CM_NB[1,2])*100)
Precision_NB

# prepare data frame for ensemble model
Data_Ensemble <- data.frame(cbind(Predict_C50, Predict_RF, 
                                  Predict_NB,  Response = test.cart$Target))

# rename ensemble data frame
names(Data_Ensemble) <- c("Decision", "RandomForest","naiveBayes","Response")

# study data ensemble
summary(Data_Ensemble)
str(Data_Ensemble)

# factorise attribute
Data_Ensemble$Response <- as.factor(Data_Ensemble$Response)

# check for missing values
sum(is.na(Data_Ensemble))

# ///////////////////// BUILD ENSEMBLE MODEL /////////////////

# run a logistic regression model on ensemble
Ensemble_model <- glm(formula = Response ~ ., data = Data_Ensemble, family = binomial)

# study ensemble model
summary(Ensemble_model)

# predict ensemble model
predict_ensemble <- predict.glm(object = Ensemble_model, newdata = Data_Ensemble[,-5], 
                                type = 'response')

# recode logistic attribute
predict_ensemble <- ifelse(test = predict_ensemble > 0.5, yes = 1, no = 0)


############################## Confusion Matrix ###########################

ConfusionMatrix <- table(test$Target, predict_ensemble)
ConfusionMatrix

Accuracy <- sum(diag(ConfusionMatrix))/sum(ConfusionMatrix)*100

Recall <- ((ConfusionMatrix[2,2])/(ConfusionMatrix[2,2]+ConfusionMatrix[2,1])*100)

Precision <- ((ConfusionMatrix[2,2])/(ConfusionMatrix[2,2]+ConfusionMatrix[1,2])*100)

Accuracy
Recall
Precision

#########################################   END    ##############################################

