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
#######################################################
#######################################################
#######################################################
##PROFIL 2 von Martin Thalheimer
##  Horizont Ap1
portions <- c(11,43,10,36)
breaks <- c(0.002,0.05,0.1,2)
textur <- schluff_oe(portions = portions,breaks=breaks)
textur
textur_oe(t=textur[1],u=textur[2])
#######################################################
##  Horizont Ap2
portions <- c(10,44,10,36)
breaks <- c(0.002,0.05,0.1,2)
textur <- schluff_oe(portions = portions,breaks=breaks)
textur
textur_oe(t=textur[1],u=textur[2])
#######################################################
##  Horizont C
portions <- c(5,29,11,55)
breaks <- c(0.002,0.05,0.1,2)
textur <- schluff_oe(portions = portions,breaks=breaks)
textur
textur_oe(t=textur[1],u=textur[2])
#######################################################
##  Horizont Ab
portions <- c(13,49,12,26)
breaks <- c(0.002,0.05,0.1,2)
textur <- schluff_oe(portions = portions,breaks=breaks)
textur
textur_oe(t=textur[1],u=textur[2])
#######################################################
#######################################################
#######################################################
#######################################################
##PROFIL X von Martin Thalheimer
##  Horizont 
portions <- c()
breaks <- c(0.002,0.05,0.1,2)
textur <- schluff_oe(portions = portions,breaks=breaks)
textur
textur_oe(t=textur[1],u=textur[2])
#######################################################
##  Horizont 
portions <- c()
breaks <- c(0.002,0.05,0.1,2)
textur <- schluff_oe(portions = portions,breaks=breaks)
textur
textur_oe(t=textur[1],u=textur[2])
#######################################################
##  Horizont 
portions <- c()
breaks <- c(0.002,0.05,0.1,2)
textur <- schluff_oe(portions = portions,breaks=breaks)
textur
textur_oe(t=textur[1],u=textur[2])
#######################################################
##  Horizont 
portions <- c()
breaks <- c(0.002,0.05,0.1,2)
textur <- schluff_oe(portions = portions,breaks=breaks)
textur
textur_oe(t=textur[1],u=textur[2])
#######################################################
