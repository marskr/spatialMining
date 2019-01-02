# save results of clustering to txt file
saveResultsToTxt = function(filename, df) {

    sink(filename, append = TRUE)

    print(paste0(df))

    print("************************************************")

    sink()
}

writeLogToTxt = function(filename, result, eps, minPts, datasetSize) {

    sink(filename, append = TRUE)

    print(paste0(">>> user time: ", round(result[1], 2)))
    print(paste0(">>> system time: ", round(result[2], 2)))
    print(paste0(">>> elapsed time: ", round(result[3], 2)))

    print(paste0(">>> settings: ", eps, " is epsilon, ", minPts, " are min pts, ", datasetSize, " are tested rows no."))

    print("************************************************")

    sink()
}

plotClustering = function(df) {

    maxLat = round(max(df$latitude) + 0.01, 2)
    minLat = round(min(df$latitude) - 0.01, 2)
    maxLon = round(max(df$longitude) + 0.01, 2)
    minLon = round(min(df$longitude) - 0.01, 2)

    plot(c(minLon, maxLon), c(minLat, maxLat), type = "n",
                                           xlab = "latitude",
                                           ylab = "longitude"
                                       )

    #df1 = subset(df, df$health_state == "zly" & df$label != -1)
    df1 = subset(df, df$label != -1)
    clustersNo = length(unique(df1$label))
    uniqueClusters = unique(df1$label)

    rbPal <- colorRampPalette(c('red', 'blue'))
    colors <- rbPal(clustersNo)

    k = 0

    for (i in uniqueClusters) {

        inc(k)
        df2 = subset(df1, df1$label == i)
        points(df2$longitude, df2$latitude, col = colors[k], lwd = 2)
    }
}

