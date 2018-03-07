library(lattice)
require(e1071)
require(rgdal)
require(rgrass7)

dependentnr=1
parameter="minic_ws9_hr_hr"
parameternamegrass="minic_ws9_hr"

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
######LOAD THE MODELDATA
dependent=dependentlist[dependentnr]
load(paste("./data/modeldata/SVMorigmodeldatawithgeoandgeom_",dependent,".RData",sep=""))
str(origmodeldata[dependent])
###################################################################################
##########BOXPLOTS FOR SOIL PROFILES
ylim=c(summary(origmodeldata[[parameter]])[1],summary(origmodeldata[[parameter]])[6])



boxplot(data=origmodeldata[c(as.character(parameter),dependent)],
        as.formula(paste(as.character(parameter),"~ ", dependent,sep=" ")),
        outline=T,
        main=as.character(parameter),
        ylim=ylim,
        varwidth=F)
for (i in 1:5){
text(labels=paste('n = ',nrow(origmodeldata[origmodeldata[[dependent]] == i,]),sep=""),x=i,y=ylim[1])
}


cl1="TG"
dependent="correct"
relevantmodeldata <- modeldataoktober[(modeldataoktober$SGU_kartiert == as.character(cl1)),]
relevantmodeldata$correct <- ifelse(relevantmodeldata$SGU_kartiert == relevantmodeldata$SGU_gk,1,0)
relevantmodeldata$correct<-as.factor(relevantmodeldata$correct)
svg(paste(proj2path,"/figure/studyarea_statistics/boxplot_TG_internal_VR43.svg",sep=""))
boxplot(data=relevantmodeldata[c(as.character(parameter),dependent)],as.formula(paste(as.character(parameter),"~ ", dependent,sep=" ")),outline=T,main=as.character(parameter),ylim=ylim)  
dev.off()
