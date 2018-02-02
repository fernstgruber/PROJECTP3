require(e1071)
require(RCurl)
require(repmis)
require(randomForest)
require(rgdal)
#proj3path="/home/fabs/PROJECTP3"
proj3path="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3/"
setwd(proj3path)
load(file="./data/preppeddata.RData")
load(file="./data/SGUinfo.RData")
#myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
#eval(parse(text = myfunctions))
allpreds <- c(localterrain,regionalterrain,roughness,heights)
paramsets <- list(localterrain,regionalterrain,roughness,heights,allpreds)
paramsetnames <- c("localterrain","regionalterrain","roughness","heights","allpreds")
dependentlist=names(preppeddata)[36:50]
allpreds <- c(localterrain,regionalterrain,roughness,heights)
allpreds <- c(allpreds[allpreds %in% names(preppeddata)])
mdata <- preppeddata[c("profilnummer",dependentlist,allpreds)]
nadata <- na.omit(mdata)
problempunkte <- mdata[!(mdata$profilnummer %in% nadata$profilnummer),]
mdata <- na.omit(mdata)
mdata$profilnummer %in% SGUinfo$ID
mdata <- merge(mdata,SGUinfo,by.x="profilnummer",by.y="ID",all.x=T)
#profiledata <- profiledata[profiledata$ID != "12884", ]
dependent = dependentlist[1]
for (dependent in dependentlist){
mdata[[dependent]] <- droplevels(mdata[[dependent]]) 

badones <-vector()
for(pp in allpreds){
    if(nrow(mdata[is.na(mdata[[pp]]),]) > 0) {
        badones <-c(badones,pp)
      }
}
 for (p in allpreds){
  if (summary(mdata[[p]])[5] == 0.0 ) {
    badones <- c(badones,p)
  }
}
allpreds=allpreds[!(allpreds %in% badones)]
paramsets[[5]] <- c(allpreds,"SGU","SGUT_wTGnew","SGUcode_vectorruggedness_hr_ws57_TRI_hr_ws31")
regionalterrain <- regionalterrain[regionalterrain %in% allpreds]
paramsets[[2]] <- regionalterrain
roughness <- roughness[roughness %in% allpreds]
roughness <-roughness[roughness %in% names(mdata)]
paramsets[[3]] <- roughness
allpreds <- c(localterrain,regionalterrain,roughness,heights,"SGU","SGUT_wTGnew","SGUcode_vectorruggedness_hr_ws57_TRI_hr_ws31")
allpreds <- allpreds[allpreds %in% names(mdata)]
origmodeldata <- mdata[names(mdata) %in% c(dependent,allpreds)]
#save(origmodeldata,paramsets,paramsetnames,dependent,file=paste("./data/modeldata/SVMorigmodeldatawithoutgeo_",dependent,".RData",sep="")) }

psets <- c(5)
classes <-  levels(origmodeldata[[dependent]])
#save(classes,paramsets,modeldata,paramsetnames,file="classesandparamsets.RData")
#paramsetnames = paramsetnames[psets]
#paramsets = paramsets[psets]

n=5
p=paramsets[psets]
#p=paramsets[1]
#for (p in paramsets){
  predset_name <- paramsetnames[n]
  preds <- unlist(p)
  preds <- preds[preds %in% allpreds]
  predset= c(preds)
  mymodeldata <- origmodeldata[c(dependent,predset)]
  folds = sample(rep(1:5, length = nrow(mymodeldata)))
  
  tt=1:10 #number of best parameters in combination
  mydir=paste("./data/SVMwithgeo_fw_5fold_10p_",dependent,"_",predset_name,sep="")
  dir.create(mydir)
  #############################################################################################################################
  #############################################################################################################################
  k=5
  for(k in 1:5){
    kmodeldata=mymodeldata[folds != k,]
    ktestdata =  mymodeldata[folds == k,]
    keepers <- vector()
    pred_df_orig <- data.frame(preds = as.character(predset))
    pred_df_orig$index <- 1:nrow(pred_df_orig)
    pred_df <- pred_df_orig
    result_df <- data.frame(tt)
    predictions_metrics <- data.frame(index=as.character(unique(pred_df$preds)))
    predset_new <- predset
    t=1
    for(t in tt){
      predictions_metrics <- predictions_metrics
      predset_new <-predset_new[!(predset_new %in% keepers)]
      seed=sample(1:1000,1)
      g=predset_new[1]
      for(g in predset_new){
        starttime <- proc.time()
        set.seed(seed)
        modelcols <- c(dependent,g,keepers)
        modeldata <- kmodeldata[names(kmodeldata) %in% modelcols]
        f <- paste(dependent,"~.")
        fit <- do.call("svm",list(as.formula(f),modeldata,cross=5))
        cverror = 1-(fit$tot.accuracy)/100
        predictions_metrics[predictions_metrics$index== eval(g),"cverror"] <- cverror
        endtime <- proc.time()
        time <- endtime - starttime
        print(paste(g, " with cverror error.rate of ",cverror, "and time =",time[3]))
        #######################################################################
      }
      predictions_metrics <- predictions_metrics[order(predictions_metrics$cverror),]
      
      minindex <- predictions_metrics[predictions_metrics$cverror == min(predictions_metrics$cverror),"index"][1]
      print(paste("###########################################################################################################################################################remove the metric ",minindex,"##############################################################################################################################################################",sep=""))
      result_df[t,"metric"] <- minindex
      result_df[t,"cverror"] <- predictions_metrics[predictions_metrics$index == minindex,"cverror"]
      keepers[t] <-as.character(minindex)
      modelcols <- c(dependent,keepers)
      modeldata <- modeldata <- kmodeldata[names(kmodeldata) %in% modelcols]
      modeldata <- na.omit(modeldata)
      set.seed(seed)
      fit <- do.call("svm",list(as.formula(f),modeldata,cross=5))
      preds=predict(fit,newdata=ktestdata)
      prederror=mean(ktestdata[[dependent]] != preds)
      result_df[t,"geheimerprederror"] <- prederror
      print(paste("geheimerprederror = ",prederror,sep=""))
      testdatatable <- table(ktestdata[[dependent]])
      traindatatable<- table(kmodeldata[[dependent]])
      save(predictions_metrics,result_df,fit,keepers,traindatatable,testdatatable,file=paste(mydir,"/k",k,"_round_",t,".RData",sep=""))
      predictions_metrics <- predictions_metrics[predictions_metrics$index != as.character(minindex),]
      
    }#iteration through tt
  }#iteration through k
#  n=n+1
#} #iteration through paramsets


}   #iteration through dependentlist
