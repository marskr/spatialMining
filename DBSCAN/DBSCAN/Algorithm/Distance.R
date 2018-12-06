ComputeDistance = function(lat1, long1, lat2, long2) {

    dist_km = distGeo(matrix(c(long1, lat1), ncol = 2),
                      matrix(c(long2, lat2), ncol = 2)) / 1000

    dist_km
}

## Example:
#lat1 = treesFrame$latitude[1]
#lat2 = treesFrame$latitude[2]

#long1 = treesFrame$longitude[1]
#long2 = treesFrame$longitude[2]

#ComputeDistance(lat1, long1, lat2, long2)