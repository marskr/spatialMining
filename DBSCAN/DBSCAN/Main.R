library(geosphere)

source("Data/ConnectionToDB.R")
source("Data/Transformations.R")
source("Algorithm/Distance.R")
source("Algorithm/DBSCAN.R")

treesFrame = preprocessDataset(treesFrame)

eps = 0.01
minPts = 2

DBSCAN(treesFrame, eps, minPts)
