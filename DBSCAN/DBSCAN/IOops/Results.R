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