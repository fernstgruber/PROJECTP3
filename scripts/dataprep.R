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
spatialdata <- readOGR("./data/shapesSEPP/Profilpunktemitboden_UTM.shp",layer="Profilpunktemitboden_UTM")
pointdata <- spatialdata@data
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
