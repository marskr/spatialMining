library(geosphere)
library(rlist)

source("Data/ConnectionToDB.R")
source("Data/Transformations.R")
source("Algorithm/Distance.R")
source("Algorithm/DBSCAN.R")

idSeq = as.data.frame(seq(1, dim(treesFrame)[1], 1))

label = as.data.frame(rep(0, dim(treesFrame)[1]))

colnames(idSeq) = c("id")

colnames(label) = c("label")

treesFrame = cbind(idSeq, treesFrame)

treesFrame = cbind(treesFrame, label)

eps = 0.01
minPts = 2

DBSCAN(treesFrame, eps, minPts)

