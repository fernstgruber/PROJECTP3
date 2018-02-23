
require(e1071)
require(RCurl)
require(repmis)
require(randomForest)
require(rgdal)
myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
eval(parse(text = myfunctions))
#proj3path="/home/fabs/PROJECTP3"
proj3path="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3/"
setwd(proj3path)
load('./data/dependentlists.RData')


#######################################
######################################
#######################################

i=1
fullpredlist <- vector()
predictorlist <- list()
for(i in 1:length(dependentlist)){
  dep=dependentlist[i]
  print(dependentlist_eng[i])
  preds <- evaluateforwardCV_anyerror(mypath=paste("./data/FSCV/SVM_geoandgeom/SVMwithgeoandgeom_fw_5fold_10p_",dep,"_allpreds",sep=""),kk=1:5,endround = 10,error = "cverror",geheim = "geheimerprederror",yrange=c(0,1))
    predictors = vector()
  for (n in 1:ncol(preds)){
    for (n2 in 1:nrow(preds)){
      predictors <- c(predictors,as.character(preds[n2,n]))
    }
  } 
  uniquepredictors <- unique(predictors)
  predictorlist[[1]] <- uniquepredictors
  fullpredlist <- c(fullpredlist,uniquepredictors)
  }
fullpredlist <- unique(fullpredlist)
save(fullpredlist,predictorlist,file=("./data/modeldata/predictorlists_SVM.RData"))


####################################
######################Lets get the best two preds of each CV-run for geomandlocal
i=1
fullpredlist <- vector()
predictorlist <- list()
for(i in 1:length(dependentlist)){
  dep=dependentlist[i]
  print(dependentlist_eng[i])
  preds <- evaluateforwardCV_anyerror(mypath=paste("./data/FSCV/SVM_localandgeom/SVMwithgeoandgeom_fw_5fold_6p_",dep,"_geomandlocal",sep=""),kk=1:5,endround = 6,error = "cverror",geheim = "geheimerprederror",yrange=c(0,1))
  predictors = vector()
  for (n in 1:ncol(preds)){
    for (n2 in 1:2){
      predictors <- c(predictors,as.character(preds[n2,n]))
    }
  } 
  uniquepredictors <- unique(predictors)
  predictorlist[[1]] <- uniquepredictors
  fullpredlist <- c(fullpredlist,uniquepredictors)
}
fullpredlist <- unique(fullpredlist)
save(fullpredlist,predictorlist,file=("./data/modeldata/predictorlists_SVM_localandgeomtop2.RData"))
