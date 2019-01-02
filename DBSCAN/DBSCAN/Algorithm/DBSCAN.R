
# Find all points in dataset `D` within distance `eps` of point `P`.
# This function calculates the distance between a point P and every other
# point in the dataset, and then returns only those points which are within a
# threshold distance `eps`.

regionQuery = function(D, P, eps) {

    neighbors = c()

    point = subset(D, D$id == P, select = c(latitude, longitude))

    for (j in 1:dim(D)[1]) {

        distance = ComputeDistance(D[j, 2], D[j, 3], point$latitude, point$longitude)
        if (distance < eps) {

            neighbors = cbind(neighbors, treesFrame[j, 1])
        }
    }
    neighbors
}

#Grow a new cluster with label `C` from the seed point `P`.
#This function searches through the dataset to find all points that belong
#to this new cluster. When this function returns, cluster `C` is complete.

#Parameters:
#`D`      - The dataset (a list of vectors)
#`labels` - List storing the cluster labels for all dataset points
#`P`      - Index of the seed point for this new cluster
#`C`      - The label for this new cluster.
#`eps`    - Threshold distance
#`MinPts` - Minimum required number of neighbors

growCluster = function(D, P, C, eps, minPts) {

    SearchQueue = c(P)

    # For each point in the queue:
    #   1. Determine whether it is a branch or a leaf
    #   2. For branch points, add their unclaimed neighbors to the search queue
    k = 0

    while (k < length(SearchQueue)) {

        # Get the next point from the queue
        P = SearchQueue[k + 1]

        neighborPts = regionQuery(D, P, eps)

        # If the number of neighbors is below the minimum, then this is a leaf
        # point and we move to the next point in the queue.
        if (dim(neighborPts)[2] < minPts) {

            inc(k)
            next
        }

        # Otherwise, we have the minimum number of neighbors, and this is a
        # branch point.
        # For each of the neighbors...

        for (Pn in neighborPts) {

            # If Pn was labelled NOISE during the seed search, then we
            # know it's not a branch point (it doesn't have enough
            # neighbors), so make it a leaf point of cluster C and move on.
            if (D[Pn, 5] == -1) {

                D[Pn, 5] = C
            }
            # Otherwise, if Pn isn't already claimed, claim it as part of
            # C and add it to the search queue.
            else if (D[Pn, 5] == 0) {

                # Add Pn to cluster C.
                D[Pn, 5] = C

                # Add Pn to the SearchQueue.
                SearchQueue = c(SearchQueue, Pn)
            }
        }

        # Advance to the next point in the FIFO queue.
        inc(k)

        # We've finished growing cluster C!
    }

    D
}


DBSCAN = function(D, eps, minPts) {

    #Cluster the dataset `D` using the DBSCAN algorithm.
    #MyDBSCAN takes a dataset `D` (a list of vectors), a threshold distance
    #`eps`, and a required number of points `MinPts`.

    #It will return a list of cluster labels. The label -1 means noise, and then
    #the clusters are numbered starting from 1.

    # C is the ID of the current cluster.
    C = 0

    for (j in 1:dim(D)[1]) {

        # Only points that have not already been claimed can be picked as new
        # seed points.
        # If the point's label is not 0, continue to the next point.
        if (D[j, 5] != 0)
            next

        #print(treesFrame[j, 4])

        P = j

        # Find all of P's neighboring points.
        neighborPts = regionQuery(D, P, eps)

        # If the number is below MinPts, this point is noise.
        # This is the only condition under which a point is labeled
        # NOISE--when it's not a valid seed point. A NOISE point may later
        # be picked up by another cluster as a boundary point (this is the only
        # condition under which a cluster label can change--from NOISE to
        # something else).
        if (dim(neighborPts)[2] < minPts)
            D[j, 5] = -1
        # Otherwise, if there are at least MinPts nearby, use this point as the
        # seed for a new cluster.
        else {

            # Get the next cluster label.
            inc(C)

            # Assing the label to our seed point.
            D[j, 5] = C

            # Growing cluster from seed point
            # growCluster(D, labels, P, C, eps, minPts)
            D = growCluster(D, P, C, eps, minPts)
        }
    }

    D
}
