library(dbscan)
library(geosphere)
library(XML)

datasetSize = getSettings(settingsFilename)[[3]]

source("Data/ConnectionToDB.R")
source("Data/Transformations.R")
source("Algorithm/Distance.R")
source("Algorithm/DBSCAN.R")
source("IOops/Settings.R")
source("IOops/Results.R")

settingsFilename = "C:/GithubRepos/spatialMining/DBSCAN/DBSCAN/IOops/Settings.xml"
resultsFilename = "C:/GithubRepos/spatialMining/DBSCAN/DBSCAN/Results.txt"
logFilename = "C:/GithubRepos/spatialMining/DBSCAN/DBSCAN/Log.txt"

treesFrame = preprocessDataset(treesFrame)

eps = getSettings(settingsFilename)[[1]]
minPts = getSettings(settingsFilename)[[2]]

start1 <- proc.time()

df = DBSCAN(treesFrame, eps, minPts)

stop1 <- proc.time()

result1 = stop1 - start1

saveResultsToTxt(resultsFilename, df)

writeLogToTxt(logFilename, result1, eps, minPts, datasetSize)
