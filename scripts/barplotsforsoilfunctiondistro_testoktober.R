
require(e1071)
require(RCurl)
require(repmis)
require(randomForest)
require(rgdal)
require(knitr)
proj3path="/home/fabs/PROJECTP3"
#proj3path="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3/"
pathtobarplots = "./Figures/barplots_SFtest/"
setwd(proj3path)
load(file=paste(proj3path, "/data/preppeddata.RData",sep=""))
dependentlist=names(preppeddata)[36:50]
dependentlist_eng <- c("1a.2.1 - Potential as a habitat for drought-tolerant species",
                       "1a.2.2 - Potential as a habitat for moisture-tolerant species",
                       "1a.3 - Habitat for soil organisms",
                       "1a.4 - Habitat for crops",
                       "1c.1 - Average precipitation retention capacity",
                       "1c.1 - Minimum precipitation retention capacity",
                       "1c.2 - Retention capacity for heavy precipitation events",
                       "1c.3 - groundwater reformation rate",
                       "1c.4 - Potential for providing nutrients for plants",
                       "1c.5 - Potential as a CO2 sink",
                       "1d.1 - Potential for retention of heavy metals",
                       "1d.2 - Potential for transforming organic contaminants",
                       "1d.3 - Potential as filter and buffer for organic contaminants",
                       "1d.4 - Potential for retention of water-soluble contaminants",
                       "1d.5 - Potential as buffer for acidic contaminants")              
myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
eval(parse(text = myfunctions))
for (i in dependentlist){
  preppeddata[[i]] <- factor(preppeddata[[i]],levels=1:5)
}
i =1
for ( i in 1:15 ){
dependent=dependentlist[i]
tbl <- table(preppeddata[dependentlist[i]])
tbl_df <- as.data.frame(tbl)
tbl_df$perc <- tbl_df$Freq / sum(tbl_df$Freq) *100
svg(paste(pathtobarplots,dependentlist[i],"_distro.svg",sep=""))
barplot(height=tbl_df$perc, ylim=c(0,110), main=dependentlist_eng[i],space=0)
for (j in 1:5){
  text(labels=paste('n = ',nrow(preppeddata[preppeddata[[dependent]] == j,]),sep=""),x=j-0.5,y=100)
}
dev.off()
}
