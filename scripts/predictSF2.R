#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
##TO TO: die region passt nicht!, schreib funktion um mapset zu entfernen!
library(lattice)
require(e1071)
require(rgdal)
require(rgrass7)

if (length(args)==0) {
  stop("USAGE: dependentnr predictorsascharacter  oldpredictorsascharacter  \n", call.=FALSE)
} else  {
  # default output file
  dependentnr = as.numeric(args[1])
  
  predictorsarg = as.character(args[2])
  predlist=c(strsplit(predictorsarg,split=","))
  predictors = unlist(predlist)
  predictorsarg = as.character(args[3])
  predlist=c(strsplit(predictorsarg,split=","))
  oldprednames = unlist(predlist)
}
#dependentnr=2
#predictors = c("Longitudinal_Curvature_hr","geom_10m_fl10_L70")
#oldprednames=c("Longitudinal_Curvature_hr","geom_10m_fl10_L70")
#proj3path="/home/fabs/PROJECTP3"
proj3path="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3/"
setwd(proj3path)
load('./data/dependentlists.RData')
load(file="./data/modeldata/predictorlists_SVM_localandgeomtop2.RData")
###setup GRASS################################################################################
gisBase="/usr/local/src/grass70_release/dist.x86_64-unknown-linux-gnu"                       #
gisDbase =  "/media/fabs/Volume/Data/GRASSDATA/"                                             #
#gisDbase =  "/home/fabs/Data/GRASSDATA/"                                                     #
location="EPPAN_vhr"                                                                         #
mapset="PERMANENT"                                                                           #
##############################################################################################
###check predictorlists#####################################################################################################################################
res10m_dtm <- c( "minic_ws3","slope_ws11","profc_ws15",  "maxic_ws15", "GeneralCurvature","minic_ws11", "crosc_ws11", "longc_ws15",
                 "MinimalCurvature",  "profc_ws11", "profc_ws5",  "minic_ws15", "crosc_ws5", "profc_ws3","LongitudinalCurvature",
                 "maxic_ws3", "maxic_ws7","MaximalCurvature","PlanCurvature", "slope_ws5" , "planc_ws11")
res50m_mitsaga <- c("slope_DTM_50m_avg_ws3","Slope","longc_DTM_50m_avg_ws11","slope_DTM_50m_avg_ws7","crosc_DTM_50m_avg_ws11",
                    "slope_DTM_50m_avg_ws5", "profc_DTM_50m_avg_ws7", "minic_DTM_50m_avg_ws3", "Flow_Line_Curvature",  "minic_DTM_50m_avg_ws5",
                    "minic_DTM_50m_avg_ws11", "planc_DTM_50m_avg_ws3", "Profile_Curvature", "Tangential_Curvature", "longc_DTM_50m_avg_ws3",
                    "longc_DTM_50m_avg_ws7",  "planc_DTM_50m_avg_ws11", "Convexity", "General_Curvature")
predsgeom <- c("geom_dtm_10m_hyd_fl5_L10","geom_10m_fl3_L3" ,"geom_10m_fl4_L10","geom_10m_fl4_L9","geom_10m_fl8_L16","geom_10m_fl10_L70",
               "geom_10m_fl10_L17","geom_10m_fl10_L6","geom_10m_fl8_L7", "geom_10m_fl10_L10" , "geom_10m_fl10_L27" ,"geom_10m_fl8_L11",
               "geom_10m_fl10_L5","geom_dtm_10m_hyd_fl5_L5","geom_10m_fl10_L7","geom_10m_fl8_L50" ,"geom_10m_fl8_L9","geom_10m_fl1_L100",
               "geom_10m_fl1_L10" ,"geom_10m_fl8_L28","geom_10m_fl10_L3" ) 
dtm_hr <- c("minic_ws9_hr","Total_Curvature_hr","Longitudinal_Curvature_hr" ,"crosc_ws11_hr", "crosc_ws3_hr","minic_ws7_hr","CrossSectionalCurvature_hr",
            "Slope_hr","slope_ws15_hr","dtm_hr_CONVEX_r30","slope_ws3_hr", "slope_ws13_hr","slope_ws19_hr","crosc_ws19_hr",
            "Flow_Line_Curvature","maxic_ws3_hr","crosc_ws23_hr","planc_ws29_hr", "minic_ws3_hr",  "maxic_ws5_hr",  "minic_ws23_hr",
            "profc_ws3_hr","maxic_ws19_hr", "longc_ws23_hr","minic_ws15_hr", "minic_ws19_hr","minic_ws5_hr","slope_ws5_hr",
            "crosc_ws5_hr","profc_ws29_hr", "minic_ws11_hr", "slope_ws11_hr", "Plan_Curvature_hr", "maxic_ws11_hr",
            "planc_ws11_hr","crosc_ws29_hr","planc_ws5_hr","planc_ws23_hr")
allpredictors <- c(res10m_dtm,res50m_mitsaga,predsgeom,dtm_hr)

######################################################################################
##############################################################################################################
##############################################################################################################
##############################################################################################################
############################################################################################################################################################
####SET PREDICTORS AND DEPENDENT#############################################################
dependent=dependentlist[dependentnr]

### get raster names##########################################################################
ST = "SUEDTIROL_DTM_NEU"                                                                     #
ST_mapsets= list.dirs(paste(gisDbase,"/",ST,sep=""),recursive = F,full.names = F)            #
EPPAN_mapsets= list.dirs(paste(gisDbase,"/",location,sep=""),recursive = F,full.names = F)   #                 
allrast_ST =vector()                                                                         #
for(ms in ST_mapsets){                                                                       #
  vects <- list.files(paste(gisDbase,"/",ST,"/",ms,"/",'cats',sep=""))                       #
  allrast_ST <- c(allrast_ST,vects)                                                          #
}                                                                                          #
allrast_EPPAN = vector()                                                                     #
for(ms in EPPAN_mapsets){                                                                    #
  vects <- list.files(paste(gisDbase,"/",location,"/",ms,"/",'cats',sep=""))                 #
  allrast_EPPAN <- c(allrast_EPPAN,vects)                                                    #
}                                                                                            #
##############################################################################################
pot_ST <- ST_mapsets[c(10:19)]
#pot_EPPAN <- EPPAN_mapsets[c(4:10)]
pot_EPPAN <- EPPAN_mapsets
##############################################################################################
initGRASS(gisBase = gisBase,gisDbase = gisDbase,location=location,mapset=mapset,override = TRUE)
mapsetnew=paste("temppredict_",dependent,sep="")
try(execGRASS("g.mapset",flags=c("c"), mapset=mapsetnew))
execGRASS("g.region" ,flags=c("p"),raster="dtm_hr_eppan@PERMANENT") #hier fehlt noch der raster!
execGRASS("g.copy", vector="SGU@paper3data_predictparentmaterial,SGU")
execGRASS("v.to.rast",input="SGU",output="SGU",use="val")
execGRASS("r.mask", raster="SGU")
p=predictors[1]
for (p in predictors){
  if (p %in% c(res10m_dtm,predsgeom,res50m_mitsaga)){
    for (ms in pot_ST){
      rasts <-  list.files(paste(gisDbase,"/",ST,"/",ms,"/",'cats',sep=""))
      if (p %in% rasts) {
        try(execGRASS("r.proj",location=ST,mapset=ms,input=p))
        try(execGRASS("r.mapcalc", expression= paste(p," = ",p),flags=c("overwrite")))
        try(execGRASS('r.out.gdal',input=p, output=paste('/mnt/bola/rebo/5_Daten/Fabian_ausmisten/fits/tifs2/',p,'.tif',sep=""), type='Float64', createopt="PROFILE=GEOTIFF,TFW=YES"))
        break}}
  }else {
    for (ms in EPPAN_mapsets){
      rasts <-  list.files(paste(gisDbase,"/",location,"/",ms,"/",'cats',sep=""))
      if(p %in% rasts){
        try(execGRASS("g.copy",raster=paste(p,"@",ms,",",p,sep="")))
        try(execGRASS("r.mapcalc", expression= paste(p," = ",p),flags=c("overwrite")))
        try(execGRASS('r.out.gdal',input=p, output=paste('/mnt/bola/rebo/5_Daten/Fabian_ausmisten/fits/tifs2/',p,'.tif',sep=""), type='Float64', createopt="PROFILE=GEOTIFF,TFW=YES"))
        break}}
  }
}
execGRASS("g.list",type="rast",mapset=mapsetnew)
######LOAD THE MODELDATA
load(paste("./data/modeldata/SVMorigmodeldatawithgeoandgeom_",dependent,".RData",sep=""))
modelcols <- c(dependent,oldprednames)
pred1 <-readRAST(paste(predictors[1],"@",mapsetnew,sep=""))
data <- pred1@data
if(length(predictors)>1){
  for (i in predictors[2:length(predictors)]){
    temp <- readRAST(i)@data
    data[[i]] <- temp[[i]]
  }
}
names(data) <- oldprednames
data$UID <- 1:nrow(data)
###was ist mit NA ? ist das jetzt ein Factor? oder muss ich vorher schon na.omit() machen
modeldata <- origmodeldata[c(modelcols)]
preddata <- na.omit(data)
p=predictors[1]
for (p in predictors){
  if (p %in% predsgeom){
    id <- which(predictors==p)
    str(modeldata[oldprednames[id]])
    str(preddata[oldprednames[id]])
    preddata[[oldprednames[id]]]<-factor(preddata[[oldprednames[id]]],levels=levels(modeldata[[oldprednames[id]]]))
  }
}
summary(preddata)
f <- paste(dependent,"~.")
fit <- do.call("svm",list(as.formula(f),modeldata,cross=10))
print(fit$tot.accuracy)

#predictions <- predict(fit,newdata=preddata)
preddata[["preds"]] <- predict(fit,newdata=preddata)
modeldata[["preds"]] <- predict(fit,newdata=modeldata)
hist <- table(preddata$preds)
CM <- table(modeldata$preds,modeldata[[dependent]])
save(fit,CM,hist,modeldata,file=paste("/mnt/bola/rebo/5_Daten/Fabian_ausmisten/fits/",paste(predictors,sep="",collapse="_et_"),"_",dependent,".RData",sep=""))
preddata[["preds"]] <- as.integer(preddata[["preds"]])
SPDF <- pred1
SPDFdata <- merge(data,preddata,by="UID",all.x=T)
SPDFdata <-SPDFdata[order(SPDFdata$UID,decreasing = F),]
SPDF@data <- SPDFdata
summary(SPDF)
outname=paste(paste(predictors,sep="",collapse="_et_"),"_",dependent,sep="")
writeRAST(SPDF["preds"],vname = outname)
execGRASS("r.to.vect",input=outname,output=outname,type="area")
execGRASS("v.out.ogr",input=outname,output=paste("/mnt/bola/rebo/5_Daten/Fabian_ausmisten/fits/shapes2/",outname,".shp",sep=""))
vect2 <- readOGR(dsn=paste("/mnt/bola/rebo/5_Daten/Fabian_ausmisten/fits/shapes2/",outname,".shp",sep=""),layer=outname)
vect2@data$value <- factor(vect2@data$value,levels=1:5)
summary(vect2)
collegend=data.frame(preds=factor(1:5),colorcol=c("forestgreen","aquamarine","purple","orange","firebrick"),stringsAsFactors = F)
#lookupTable <- unique(collegend)
#colRegions <- as.vector(lookupTable$colorcol[match(levels(vect2@data$value), lookupTable$preds)])
vect2@data$UID <- 1:nrow(vect2@data)
vect2@data <- merge(vect2@data,collegend,by.x="value",by.y="preds",all.x=T)
vect2@data <- vect2@data[order(vect2@data$UID),]
pdf(paste("/mnt/bola/rebo/5_Daten/Fabian_ausmisten/fits/plots2/",outname,".pdf",sep=""))
plot(vect2,col=vect2@data$colorcol,border="transparent",main=dependent)
legend("topright",legend=collegend$preds,fill = collegend$colorcol)
dev.off()
###################################
unlink(paste(gisDbase,location,"/",mapsetnew,sep=""), recursive = T)
