##TO TO: die region passt nicht!
require(e1071)
require(rgdal)
require(rgrass7)
proj3path="/home/fabs/PROJECTP3"
#proj3path="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3/"
setwd(proj3path)
load('./data/dependentlists.RData')
load(file="./data/modeldata/predictorlists_SVM_localandgeomtop2.RData")

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
####SET PREDICTORS AND DEPENDENT#############################################################
predictors <- c("geom_10m_fl4_L10","slope_DTM_50m_avg_ws7")
dependent=dependentlist[1]
###setup GRASS################################################################################
gisBase="/usr/local/src/grass70_release/dist.x86_64-unknown-linux-gnu"                       #
#gisDbase =  "/media/fabs/Volume/Data/GRASSDATA/"                                             #
gisDbase =  "/home/fabs/Data/GRASSDATA/"                                                     #
location="EPPAN_vhr"                                                                         #
mapset="PERMANENT"                                                                           #
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
mapsetnew=paste("predict_",dependent,sep="")
try(execGRASS("g.mapset",flags=c("c"), mapset=mapsetnew))
region <- execGRASS("g.region" ,flags=c("p"),rast="dtm_hr_eppan@dtm_hr") #hier fehlt noch der raster!
p=predictors[2]
for (p in predictors){
  if (p %in% c(res10m_dtm,predsgeom,res50m_mitsaga)){
    for (ms in pot_ST){
    rasts <-  list.files(paste(gisDbase,"/",ST,"/",ms,"/",'cats',sep=""))
    if (p %in% rasts) {
    execGRASS("r.proj",location=ST,mapset=ms,input=p)
    execGRASS("r.mapcalc", expression= paste(p," = ",p),flags=c("overwrite"))        }}
    }else {
      for (ms in ST_mapsets){
        rasts <-  list.files(paste(gisDbase,"/",location,"/",ms,"/",'cats',sep=""))
        if(p %in% rasts){
      execGRASS("g.copy",raster=paste(p,"@",ms,",",p,sep=""))}}
    }
}
execGRASS("g.list",type="rast",mapset=mapsetnew)
######LOAD THE MODELDATA
load(paste("./data/modeldata/SVMorigmodeldatawithgeo_",dependent,".RData",sep=""))
#HIER WEITERMACHEN!!!!!!!!!!!!!!!!!!!!!!1
#legend <- read.table(paste(proj2path,"data2017/SGU_legend_new.txt",sep=""),sep="\t",header=T)
#names(legend) <- c("SGU","SGUcode")
#dependent="SGU_kartiert"
modelcols <- c(dependent,predictors)
pred1 <-readRAST(predictors[1])
data <- pred1@data
for (i in predictors[2:length(predictors)]){
  temp <- readRAST(i)@data
  data[[i]] <- temp[[i]]
}
names(data) <- predictors
data$UID <- 1:nrow(data)
modeldataoktober <- merge(modeldataoktober,legend,by.x="SGU_gk",by.y="SGU")
modeldata <- modeldataoktober[c(modelcols)]
modeldata$SGUcode <- factor(modeldata$SGUcode,levels=1:15)
data$SGUcode <- factor(data$SGUcode,levels=1:15)
f <- paste(dependent,"~.")
fit <- do.call("randomForest",list(as.formula(f),modeldata))
data[["preds"]] <- predict(fit,newdata=data)
SGU_modell <- SGU_gk
names(legend) <- c("SGU","SGU_predcodes")
data <- merge(data,legend,by.x="preds",by.y="SGU",all.x=T)
data <-data[order(data$UID,decreasing = F),]
SGU_modell@data <- data
summary(SGU_modell)
outname=paste(predictors,collapse="_")
writeRAST(SGU_modell["SGU_predcodes"],vname = outname)
execGRASS("r.to.vect",input=outname,output=outname,type="area")
execGRASS("v.out.ogr",input=outname,output=paste(outname,".shp",sep=""))

