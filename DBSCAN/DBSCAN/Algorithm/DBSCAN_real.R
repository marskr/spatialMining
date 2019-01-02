# clustering fpc lib
library(dbscan)
library(ggplot2)
library(dplyr)
library(maps)

postProcessClustering = function(clustVec, D) {

    test = c()

    for (i in clustVec) {

        if (i == 0)
            test = cbind(test, -1)
        else
            test = cbind(test, i)
        }

    test = as.vector(test)

    df2 = data.frame(D[, -5], as.vector(test))

    colnames(df2) = c("id", "latitude", "longitude", "health_state", "label")

    df2
}

source("IOops/Settings.R")
source("IOops/Results.R")

head(treesFrameProcessed, 5)

treesFrameProcessed2 = subset(treesFrameProcessed, treesFrameProcessed$health_state == "zly") # | treesFrameProcessed$health_state == "sredni")

eps = getSettings(settingsFilename)[[1]]
minPts = getSettings(settingsFilename)[[2]]

clusters <- dbscan(select(treesFrameProcessed2, latitude, longitude), eps = eps, minPts = minPts)
clustVec = clusters$cluster

plotClustering(postProcessClustering(clustVec, treesFrameProcessed2))

