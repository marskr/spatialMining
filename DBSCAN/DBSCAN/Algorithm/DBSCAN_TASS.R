library(dbscan)
library(sqldf)
library(odbc)
library(ggplot2)
library(dplyr)
library(maps)

source("IOops/Settings.R")
source("IOops/Results.R")

connStr <- paste("Driver=SQL Server;Server=", "DESKTOP-8MRGK1B", ";Database=", "TASS", ";uid=;pwd=;", "trustedconnection=yes;", sep = "");

#"SELECT [TripID]
                             #,[DropoffLongitude]
                             #,[DropoffLatitude]
                             #FROM [TASS].[bi].[vw_Dropoff]
                             #WHERE DAY([DropoffDatetime]) = 14 AND MONTH([DropoffDatetime]) = 1
                                                              #AND DATEPART(HOUR, [DropoffDatetime]) >= 20"

inputQuery2 <- paste0("SELECT TOP(20000) [TripID]
                             ,[DropoffLongitude]
                             ,[DropoffLatitude]
                             FROM [TASS].[bi].[vw_Dropoff]
                             WHERE DAY([DropoffDatetime]) = 15 AND MONTH([DropoffDatetime]) = 9
                                                              AND DATEPART(HOUR, [DropoffDatetime]) >= 20")

obtainedData2 <- RxSqlServerData(sqlQuery = inputQuery2, colClasses = c(TripID = "string",
                                                                       latitude = "numeric",
                                                                       longitude = "numeric"
                                                                       ), connectionString = connStr);

pickup <- rxDataStep(obtainedData2)

#head(pickup, 100)
clusters <- dbscan(select(pickup, DropoffLatitude, DropoffLongitude), eps = 0.001, minPts = 100)
clustVec = clusters$cluster

testID = 22

test = c()

for (i in clustVec) {

    if (i == 0)
        test = cbind(test, -1)
    else
        test = cbind(test, i)
    }

test = as.vector(test)

df2 = data.frame(pickup$TripID, as.vector(test), rep(testID, length(clustVec)))

colnames(df2) = c("TripID", "Cluster", "TestID")

head(df2, 5)

df3 = data.frame(pickup$TripID, pickup$DropoffLatitude, pickup$DropoffLongitude, as.vector(test))

colnames(df3) = c("TripID", "latitude", "longitude", "label")

df4 = subset(df3, df3$latitude > 40.6 & df3$latitude < 40.9 & df3$longitude < -73.7 & df3$longitude > -74.1)

plotClustering(df4)

#con <- dbConnect(odbc(),
                 #Driver = "SQL Server",
                 #Server = "DESKTOP-8MRGK1B",
                 #Database = "TASS")

#dbWriteTable(conn = con,
             #name = "ClusteringDBSCAN",
             #value = df2,
             #append = TRUE)
