require(e1071)
require(RCurl)
require(repmis)
require(randomForest)
require(rgdal)
myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
eval(parse(text = myfunctions))
load('../data/dependentlists.RData')
#proj3path="/home/fabs/PROJECTP3/"
proj3path="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3/"
#setwd(proj3path)
dependentnr=1
#preddata[["preds"]] <- factor(preddata[["preds"]],levels=1:5)
dependent=dependentlist[dependentnr]
#load(paste("../data/modeldata/SVMorigmodeldatawithgeoandgeom_",dependent,".RData",sep=""))
predsgeom <- c("geom_dtm_10m_hyd_fl5_L10","geom_10m_fl3_L3" ,"geom_10m_fl4_L10","geom_10m_fl4_L9","geom_10m_fl8_L16","geom_10m_fl10_L70",
               "geom_10m_fl10_L17","geom_10m_fl10_L6","geom_10m_fl8_L7", "geom_10m_fl10_L10" , "geom_10m_fl10_L27" ,"geom_10m_fl8_L11",
               "geom_10m_fl10_L5","geom_dtm_10m_hyd_fl5_L5","geom_10m_fl10_L7","geom_10m_fl8_L50" ,"geom_10m_fl8_L9","geom_10m_fl1_L100",
               "geom_10m_fl1_L10" ,"geom_10m_fl8_L28","geom_10m_fl10_L3" ) 

parameters=c("geom_10m_fl4_L10","slope_DTM_50m_avg_ws7_50m")
parameter=parameters[2]
RFile="../data/rdataforstats/cv100_Leben_Tr_geom_10m_fl4_L10_slope_DTM_50m_avg_ws7_50m_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
pdf(paste("../Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
if(parameter %in% predsgeom){
  par(mfcol=c(5,2))
  for (i in 1:5){
    geombarplot(geomcol=parameter,thema=dependent,data=newmodeldatawithpreds,einheit=i,rdata=RFile)
  }
  for (i in 1:5){
    geombarplot(geomcol=parameter,thema="preds",data=newmodeldatawithpreds,einheit=i,rdata=RFile)
  }
}else {
  parameterboxplots(origmodeldata = newmodeldatawithpreds,preddata=newmodeldatawithpreds,dependent=dependent,parameter=parameter,rdata=RFile)
}
dev.off()
}
