require(e1071)
require(RCurl)
require(repmis)
require(randomForest)
require(rgdal)
myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
eval(parse(text = myfunctions))
load('./data/dependentlists.RData')
proj3path="/home/fabs/PROJECTP3/"
#proj3path="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3/"
#setwd(proj3path)
dependentnr=1
#preddata[["preds"]] <- factor(preddata[["preds"]],levels=1:5)
dependent=dependentlist[dependentnr]
#load(paste("./data/modeldata/SVMorigmodeldatawithgeoandgeom_",dependent,".RData",sep=""))
predsgeom <- c("geom_dtm_10m_hyd_fl5_L10","geom_10m_fl3_L3" ,"geom_10m_fl4_L10","geom_10m_fl4_L9","geom_10m_fl8_L16","geom_10m_fl10_L70",
               "geom_10m_fl10_L17","geom_10m_fl10_L6","geom_10m_fl8_L7", "geom_10m_fl10_L10" , "geom_10m_fl10_L27" ,"geom_10m_fl8_L11",
               "geom_10m_fl10_L5","geom_dtm_10m_hyd_fl5_L5","geom_10m_fl10_L7","geom_10m_fl8_L50" ,"geom_10m_fl8_L9","geom_10m_fl1_L100",
               "geom_10m_fl1_L10" ,"geom_10m_fl8_L28","geom_10m_fl10_L3" ) 
###########################################################
##### Potential as a habitat for drought-tolerant species
###########################################################
parameters=c("geom_10m_fl4_L10","slope_DTM_50m_avg_ws7_50m")
RFile="./data/rdataforstats/cv100_Leben_Tr_geom_10m_fl4_L10_slope_DTM_50m_avg_ws7_50m_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
###########################################################
##### Potential as a habitat for moisture-tolerant species
###########################################################
dependentnr=2
dependent=dependentlist[dependentnr]
parameters=c("Longitudinal_Curvature_hr","geom_10m_fl10_L70")
RFile="./data/rdataforstats/cv100_Leben_Fe_Longitudinal_Curvature_hr_geom_10m_fl10_L70_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
###########################################################
##### Habitat for soil organisms
###########################################################
dependentnr=3
dependent=dependentlist[dependentnr]
parameters=c("crosc_DTM_50m_avg_ws7_50m","slope_DTM_50m_avg_ws7_50m","Convexity_50m")
parameters %in% names(newmodeldatawithpreds)
RFile="./data/rdataforstats/cv100_Leben_Org_crosc_DTM_50m_avg_ws7_50m_slope_DTM_50m_avg_ws7_50m_Convexity_50m_preds.RData"
load(RFile)
parameters %in% names(newmodeldatawithpreds)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
###########################################################
##### Habitat for crops
###########################################################
dependentnr=4
dependent=dependentlist[dependentnr]
parameters=c("slope_ws3_hr_hr")
RFile="./data/rdataforstats/cv100_Leben_Kult_slope_ws3_hr_hr_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
###########################################################
##### Average precipitation retention capacity
###########################################################
dependentnr=5
dependent=dependentlist[dependentnr]
parameters=c("crosc_ws19_hr_hr","profc_ws15_10m")
RFile="./data/rdataforstats/cv100_Retent_ave_crosc_ws19_hr_hr_profc_ws15_10m_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
###########################################################
##### Minimum precipitation retention capacity
###########################################################
dependentnr=6
dependent=dependentlist[dependentnr]
parameters=c("planc_ws29_hr_hr","minic_DTM_50m_avg_ws3_50m")
RFile="./data/rdataforstats/cv100_Retent_min_planc_ws29_hr_hr_minic_DTM_50m_avg_ws3_50m_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
###########################################################
##### Retention capacity for heavy precipitation events
###########################################################
dependentnr=7
dependent=dependentlist[dependentnr]
parameters=c("longc_ws15_10m")
RFile="./data/rdataforstats/cv100_Retent_stark_longc_ws15_10m_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
###########################################################
##### groundwater reformation rate
###########################################################
dependentnr=8
dependent=dependentlist[dependentnr]
parameters=c("crosc_ws23_hr_hr","profc_ws5_10m")
RFile="./data/rdataforstats/cv100_GWneu_crosc_ws23_hr_hr_profc_ws5_10m_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
###########################################################
#####  Potential for providing nutrients for plants
###########################################################
dependentnr=9
dependent=dependentlist[dependentnr]
parameters=c("minic_ws9_hr_hr")
RFile="./data/rdataforstats/cv100_Naehrstoff_minic_ws9_hr_hr_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
###########################################################
##### Potential as a CO2 sink
###########################################################
dependentnr=10
dependent=dependentlist[dependentnr]
parameters=c("minic_ws11_hr_hr")
RFile="./data/rdataforstats/cv100_CO2_Senke_minic_ws11_hr_hr_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
###########################################################
##### Potential for retention of heavy metals
###########################################################
dependentnr=11
dependent=dependentlist[dependentnr]
parameters=c("geom_10m_fl10_L7")
RFile="./data/rdataforstats/cv100_FiltPuff_geom_10m_fl10_L7_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
###########################################################
##### Potential for transforming organic contaminants
###########################################################
dependentnr=12
dependent=dependentlist[dependentnr]
parameters=c("geom_10m_fl8_L50","maxic_ws7_10m")
RFile="./data/rdataforstats/cv100_Transform_geom_10m_fl8_L50_maxic_ws7_10m_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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

###########################################################
##### Potential for retention of water-soluble contaminants
###########################################################
dependentnr=14
dependent=dependentlist[dependentnr]
parameters=c("slope_ws11_hr_hr","minic_ws3_hr_hr")
RFile="./data/rdataforstats/cv100_FiltPuff_Nit_slope_ws11_hr_hr_minic_ws3_hr_hr_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
###########################################################
##### Potential as buffer for acidic contaminants
###########################################################
dependentnr=15
dependent=dependentlist[dependentnr]
parameters=c("planc_ws5_hr_hr","slope_ws5_hr_hr")
RFile="./data/rdataforstats/cv100_Puff_sauer_planc_ws5_hr_hr_slope_ws5_hr_hr_preds.RData"
load(RFile)
newmodeldatawithpreds[["preds"]] <- newmodeldatawithpreds[["moderesult"]]
for(parameter in parameters){
  pdf(paste("./Figures/RPLOTS/",parameter,"_",dependent,".pdf",sep=""),paper = "a4")
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
