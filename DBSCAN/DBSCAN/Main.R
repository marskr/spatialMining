library(geosphere)
library(XML)
library(ggplot2)
library(ggmap)

settingsFilename = "C:/GithubRepos/spatialMining/DBSCAN/DBSCAN/IOops/Settings.xml"
resultsFilename = "C:/GithubRepos/spatialMining/DBSCAN/DBSCAN/Results.txt"
logFilename = "C:/GithubRepos/spatialMining/DBSCAN/DBSCAN/Log.txt"

source("IOops/Settings.R")
datasetSize = getSettings(settingsFilename)[[3]]
source("Data/ConnectionToDB.R")
source("Data/Transformations.R")
source("Algorithm/Distance.R")
source("Algorithm/DBSCAN.R")
source("IOops/Results.R")

treesFrame = preprocessDataset(treesFrame)
treesFrameProcessed = treesFrame

eps = getSettings(settingsFilename)[[1]]
minPts = getSettings(settingsFilename)[[2]]

start1 <- proc.time()

df = DBSCAN(treesFrameProcessed, eps, minPts)

stop1 <- proc.time()

result1 = stop1 - start1

saveResultsToTxt(resultsFilename, df)

writeLogToTxt(logFilename, result1, eps, minPts, datasetSize)

plotClustering(df)


