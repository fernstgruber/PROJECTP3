require(e1071)
require(RCurl)
require(repmis)
require(randomForest)
library(knitr)
require(rgdal)
#paperzeugpfad <- "/media/fabs/Volume/01_PAPERZEUG/"
paperzeugpfad <- "//home/fabs/Data/"
myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
eval(parse(text = myfunctions))
load(paste(paperzeugpfad,"paper2data/profiledata.RData",sep=""))
#proj3path="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3"
proj3path="/home/fabs/PROJECTP3"
setwd(proj3path)
#spatialdata <- readOGR("./data/shapesSEPP/Profilpunktemitboden_UTM.shp",layer="Profilpunktemitboden_UTM")
#pointdata <- spatialdata@data
thalheimer <- read.table("./data/results_NOV2017/Thalheimer_AND__ReBO_profileruns/Thalheimer_all_dez162017.csv",sep="\t",header=T)
resultcolnumbers <- c(1,10:12,26,28,34,36,38,40,49,51,52,57:58,91,94,97:129)
resultcols <- names(thalheimer)[resultcolnumbers]
#WIE SCHAUTS AUS MIT GEOMORPHONS
rebo <- read.table("./data/results_NOV2017/Thalheimer_AND__ReBO_profileruns/ReBo_all_dez182017.csv",sep="\t",header=T)
resultcols %in% names(rebo)
resultcolnumbers %in% names(thalheimer)
Sepp_UE <- rbind(thalheimer[resultcols],rebo[resultcols])
summary(Sepp_UE)
factorcols <- resultcols[c(1,5,7,11,12,14,15,16,17,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50)]
for (i in factorcols){
  Sepp_UE[[i]] <- as.factor(Sepp_UE[[i]])
}
#identifier for pointdata: ID
#identifier for Sepp_Ue:profilnummer
#identifier for profiledata: ID
summary(Sepp_UE$profilnummer %in% profiledata$ID)
Sepp_UE[!(Sepp_UE$profilnummer %in% profiledata$ID),]
preppeddata = merge(Sepp_UE, profiledata,by.x="profilnummer",by.y="ID",all.x=T)
summary(preppeddata)
SGUinfo <- read.table("./data/SGUinfo_fromP2.txt",sep=",",header=T)
SGUinfo <- SGUinfo[c("ID", "SGUcode_vectorruggedness_hr_ws57_TRI_hr_ws31", "SGU" ,"SGUT_wTGnew" )]
for (i in c("SGUcode_vectorruggedness_hr_ws57_TRI_hr_ws31", "SGU" ,"SGUT_wTGnew")){
  SGUinfo[[i]] <- as.factor(SGUinfo[[i]])
}
#save(SGUinfo,file="./data/SGUinfo.RData")
geomorphons <- read.table("./data/Geominfo_fromP1.txt",sep=",",header=T)
geomcols <- names(geomorphons)[90:454]
for (i in geomcols) {
  geomorphons[[i]] <- factor(geomorphons[[i]],levels=1:10)
}
geomdata <- geomorphons[c("ID",geomcols)]
#save(geomdata,geomcols,file="./data/geomorphoninfo.RData")
#save(preppeddata,heights,localterrain, regionalterrain,roughness, file=paste(proj3path, "/data/preppeddata.RData",sep="")) 
#write.table(Sepp_UE,"./data/SEPP_results.txt",sep="\t",row.names = F)
