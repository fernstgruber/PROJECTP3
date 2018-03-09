library(lattice)
require(e1071)
require(rgdal)
require(rgrass7)
#proj3path="/home/fabs/PROJECTP3/"
proj3path="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3/"
setwd(proj3path)
###SET VARIABLES############################################################################################################
dependentnr=1
parameter="minic_ws9_hr_hr"
#parameter="geom_dtm_10m_hyd_fl5_L10"
load("/mnt/bola/rebo/5_Daten/Fabian_ausmisten/fits/geom_dtm_10m_hyd_fl5_L10_et_minic_ws9_hr_Leben_Tr.RData")


load('./data/dependentlists.RData')


preddata[["preds"]] <- factor(preddata[["preds"]],levels=1:5)
dependent=dependentlist[dependentnr]
load(paste("./data/modeldata/SVMorigmodeldatawithgeoandgeom_",dependent,".RData",sep=""))
predsgeom <- c("geom_dtm_10m_hyd_fl5_L10","geom_10m_fl3_L3" ,"geom_10m_fl4_L10","geom_10m_fl4_L9","geom_10m_fl8_L16","geom_10m_fl10_L70",
               "geom_10m_fl10_L17","geom_10m_fl10_L6","geom_10m_fl8_L7", "geom_10m_fl10_L10" , "geom_10m_fl10_L27" ,"geom_10m_fl8_L11",
               "geom_10m_fl10_L5","geom_dtm_10m_hyd_fl5_L5","geom_10m_fl10_L7","geom_10m_fl8_L50" ,"geom_10m_fl8_L9","geom_10m_fl1_L100",
               "geom_10m_fl1_L10" ,"geom_10m_fl8_L28","geom_10m_fl10_L3" ) 
####BEGIN: FUNCTIONS#######################################################################################
geombarplot <- function(geomcol,thema,einheit,data,...){
  code= c(1:10)
  geom_names=c("flat","peak","ridge","shoulder","spur","slope","hollow","footslope","valley","pit")
  n<-geom_names
  mycols <- c("#e2e0e1","#000000","#c0262a","#d78321","#e7cb3c","#fcea0d","#bfd71c","#82b16b","#3e3ab8","#000000")
  geomorphons <- as.data.frame(cbind(code,geom_names,mycols))
  if(length(na.omit(data[data[[thema]] == einheit,geomcol]))<1){
    L=data.frame("Var1" = 1:10,"Freq" = 0)
  } else{
    L<-as.data.frame(table(na.omit(data[data[[thema]] == einheit,geomcol])))
  }
  names(L) <- c("code","freq")
  L$freqrel <- L$freq/sum(L$freq) * 100
  L$code <- factor(L$code,levels=1:10)
  L <- merge(L,geomorphons,all.y=TRUE)
  L <- L[order(L$code),]
  main=paste(einheit,geomcol,sep="  -  ")
  par(mar=c(0.5,3,0.5,0))
  barplot(L$freqrel,col=mycols,cex.main=0.5,las=2,ylab="%",ylim=c(0,100),cex.axis = 0.6,cex.lab=0.7, mgp=c(2, 1, 0),main=paste(dependent," = ",i))
}
parameterboxplots <- function(origmodeldata,preddata, dependent,parameter){
  ylim=c(summary(origmodeldata[[parameter]])[1],summary(origmodeldata[[parameter]])[6])
  ylim2=c(summary(preddata[[parameter]])[1],summary(preddata[[parameter]])[6])
  
    boxplot(data=origmodeldata[c(as.character(parameter),dependent)],
          as.formula(paste(as.character(parameter),"~ ", dependent,sep=" ")),
          outline=T,
          main=as.character(parameter),
          ylim=ylim,
          varwidth=T,
          border="green")
  boxplot(data=preddata[c(as.character(parameter),"preds")],
          as.formula(paste(as.character(parameter),"~ ", "preds",sep=" ")),
          outline=T,
          main=as.character(parameter),
          ylim=ylim,
          varwidth=T,
          add=T,
          border="red")
  for (i in 1:5){
    text(labels=paste('n = ',nrow(origmodeldata[origmodeldata[[dependent]] == i,]),sep=""),x=i,y=ylim[1]+0.005)
  }
}

####END FUNCTIONS#########################################################################################


svg(paste("./Rplots/",parameter,".svg",sep=""))
if(parameter %in% predsgeom){
  par(mfcol=c(5,2))
  for (i in 1:5){
    geombarplot(geomcol=parameter,thema="Leben_Tr",data=origmodeldata,einheit=i)
  }
  for (i in 1:5){
    geombarplot(geomcol=parameter,thema="preds",data=preddata,einheit=i)
  }
  }else {
    parameterboxplots(origmodeldata,preddata,dependent=dependentlist[1],parameter=parameter)
  }
dev.off()



