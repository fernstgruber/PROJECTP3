require(e1071)
require(RCurl)
require(repmis)
require(randomForest)
library(knitr)
require(rgdal)
paperzeugpfad <- "/media/fabs/Volume/01_PAPERZEUG/"
myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
eval(parse(text = myfunctions))
load(paste(paperzeugpfad,"paper2data/profiledata.RData",sep=""))
proj3path="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3"
setwd(proj3path)
spatialdata <- readOGR("./data/shapesSEPP/Profilpunktemitboden_UTM.shp",layer="Profilpunktemitboden_UTM")
pointdata <- spatialdata@data
thalheimer <- read.table("./data/results_NOV2017/Thalheimer_AND__ReBO_profileruns/Thalheimer_all_dez162017.csv",sep="\t",header=T)
resultcolnumbers <- c(1,10:12,26,28,34,36,38,40,49,51,52,57:58,91,94,97:129)
resultcols <- names(thalheimer)[resultcolnumbers]
#WIE SCHAUTS AUS MIT GEOMORPHONS
