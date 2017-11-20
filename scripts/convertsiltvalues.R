require(RCurl)
myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
eval(parse(text = myfunctions))

##PROFIL 1 von Martin Thalheimer
##  Horizont Ap1
portions <- c(17,40,11,32)
breaks <- c(0.002,0.05,0.1,2)
textur <- schluff_oe(portions = portions,breaks=breaks)
textur
textur_oe(t=textur[1],u=textur[2])
#######################################################
##  Horizont Ap2
portions <- c(17,41,11,31)
breaks <- c(0.002,0.05,0.1,2)
textur <- schluff_oe(portions = portions,breaks=breaks)
textur
textur_oe(t=textur[1],u=textur[2])
#######################################################
##  Horizont Ap3
portions <- c(16,37,11,36)
breaks <- c(0.002,0.05,0.1,2)
textur <- schluff_oe(portions = portions,breaks=breaks)
textur
textur_oe(t=textur[1],u=textur[2])
#######################################################
##  Horizont C
portions <- c(6,36,14,44)
breaks <- c(0.002,0.05,0.1,2)
textur <- schluff_oe(portions = portions,breaks=breaks)
textur
textur_oe(t=textur[1],u=textur[2])
#######################################################

