# -*- coding: utf-8 -*-
"""
Created on Wed Mar  7 14:21:59 2018

@author: fabs
"""

import pandas as pd
import numpy as np
import os
import ogr
import simpledbf as sdb
import fnmatch
mywd="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3/data/fits/shapes/"
clipshape="/media/fabs/Volume/01_PAPERZEUG/PROJECTP3/data/SHAPEDATA/SGU_eppanvhr.shp"
os.chdir(mywd)
os.mkdir("clipped")
shapelist=[]
for file in os.listdir('.'):
    if fnmatch.fnmatch(file, '*.shp'):
        shapelist.append(file)                 
shape=shapelist[0]
shapebase=os.path.splitext(shape)[0]
cmd="ogr2ogr  -clipsrc " + clipshape +" "+ "./clipped/" +shapebase + "clip" + ".shp" + " " + shape
cmd="ogr2ogr  -clipsrc " + clipshape +" " +shapebase + "_clip" + ".shp" + " " + shape
os.system(cmd)