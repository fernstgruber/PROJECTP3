
require(e1071)
require(RCurl)
require(repmis)
require(randomForest)
require(rgdal)
myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
eval(parse(text = myfunctions))
proj3path="/home/fabs/PROJECTP3"
#proj3path="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3/"
setwd(proj3path)
load('./data/dependentlists.RData')

i=1
for(i in 1:length(dependentlist)){
  dep=dependentlist[i]
  print(dependentlist_eng[i])
  load(paste("./data/modeldata/SVMorigmodeldatawithgeoandgeom_",dep,".RData",sep=""))  
  geomandlocal=c(unlist(paramsets[[1]]),unlist(paramsets[[6]]))
paramsets[[7]] <- geomandlocal
paramsetnames[7] <- 'geomandlocal'
  preds <- evaluateforwardCV_anyerror(mypath=paste("./data/FSCV/SVM_localandgeom/SVMwithgeoandgeom_fw_5fold_6p_",dep,"_geomandlocal",sep=""),kk=1:5,endround = 6,error = "cverror",geheim = "geheimerprederror",yrange=c(0,1))
  predictors <- c(as.character(preds[1,1]),as.character(preds[2,1]))
  print(preds)
 # predict_radial_full(modeldata=origmodeldata, dependent=dep, predictors=predictors,kappasum = F,tausum = F)
    predictors = vector()
  for (n in 1:ncol(preds)){
    for (n2 in 1:nrow(preds)){
      predictors <- c(predictors,as.character(preds[n2,n]))
    }
  } 
    print("###################### WITH  PREDICTORS from the FW SELECTION ###################")
  uniquepredictors <- unique(predictors)
  save(uniquepredictors,file=paste("./data/modeldata/toppreds_",dep,".RData",sep=""))
  #predict_radial_full(modeldata=origmodeldata, dependent=dep, predictors=uniquepredictors)
  #print("######################WITH ALL GEOMANDLOCAL###################")
  #predict_radial_full(modeldata=origmodeldata, dependent=dep, predictors=unlist(paramsets[7]),printpreds = FALSE)
  rm(origmodeldata,paramsets,paramsetnames,dependent)
  
}
