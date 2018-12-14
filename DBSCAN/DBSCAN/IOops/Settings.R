# read XML settings from file 
getSettings = function(filename) {

    result <- xmlParse(file = settingsFilename)

    rootnode <- xmlRoot(result)

    settings.eps <- as.numeric(xmlToList(rootnode[[1]]))

    settings.minpts <- as.integer(xmlToList(rootnode[[2]]))

    settings.datasetsize <- as.integer(xmlToList(rootnode[[3]]))

    list(settings.eps, settings.minpts, settings.datasetsize)
}
