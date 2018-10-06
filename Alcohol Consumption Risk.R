### load packages
library(e1071)

################# code without modifying dataset #################
#### run svm model with radial method
drug <- read.csv("drug.csv")
drug <- drug[,-1]
summary(drug)
svm.model <- svm(Alcohol~.,data=drug)
summary(svm.model)

#### perform the prediction
pred<-predict(svm.model,drug)
performance<-table(predicted=pred,actual=drug$Alcohol)
performance

#### calculate the accuracy
accuracy=sum(diag(performance)/sum(performance))
accuracy

#### run the svm model again but change the parameter property (kernel is set to linear)
svm.model1<-svm(Alcohol~., data=drug, kernel="linear") 
pred<-predict(svm.model1,drug) 
performance<-table(predicted=pred, actual=drug$Alcohol)
#### examine the performance
performance

#### recalculate the accuracy
accuracy=sum(diag(performance)/sum(performance))
accuracy

#### tune the model using 10 folds cross validation
set.seed(123)
tunedmodel<- tune(svm,Alcohol~.,data=drug, ranges=list(cost=c(0.1,1,10),gamma=2^(-2:2)))
plot(tunedmodel)
summary(tunedmodel)

#### examine the best model result
bestmodel<-tunedmodel$best.model
summary(bestmodel)

################# code with modified data #################
mod.drug <- read.csv("drug.csv")
mod.drug$AlcoholUse=ifelse((drug$Alcohol=="CL0") | (drug$Alcohol == "CL1") | (drug$Alcohol=="CL2") | (drug$Alcohol=="CL3"),"Non-User","User")
mod.drug <- mod.drug[,-14]

#### modify the model
mod.drug$AlcoholUse <- as.factor(mod.drug$AlcoholUse)
mod.drug$Usage=ifelse(mod.drug$AlcoholUse=="Non-User",0,1)
View(mod.drug)

#### run model with svm and extract the prediction performance
mod.svm.model <- svm(AlcoholUse~.,data=mod.drug)
summary(mod.svm.model)
mod.pred<-predict(mod.svm.model,mod.drug)
mod.performance<-table(predicted=mod.pred,actual=mod.drug$AlcoholUse)
mod.performance

#### examine the accuracy
mod.accuracy=sum(diag(mod.performance)/sum(mod.performance))
mod.accuracy

#### tune the model
set.seed(123)
mod.tunedmodel<- tune(svm,AlcoholUse~.,data=mod.drug, ranges=list(cost=c(0.1,1,10),gamma=2^(-2:2)))
plot(mod.tunedmodel)
summary(mod.tunedmodel)

#### extract the best model after tuning
mod.bestmodel<-mod.tunedmodel$best.model
summary(mod.bestmodel)

### PCA apply
data=mod.drug[c(-1,-13,-14)]
View(data)
pca<- prcomp(data,center = TRUE)
pca
#### plot the pca to visualize principal components
plot(pca)