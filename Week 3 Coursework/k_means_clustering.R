# a relatively old technique
# helpful for summarizing high dimensional data & to find patterns in the data

# in K means clustering the following have to be defined
      # how do we define "close"?
      # how do we group data points together?
      # how to visualize the groupings?
      # how to interpret the groupings?

# similar to hierarchical clustering a distance metric needs to be selected
# the selected distance metric must be appropriate for the problem at hand

# K means clustering partitions a group of observations into a fixed number of clusters
# one needs to specify how many clusters are expected from the clustering algorithm
# each group will have a centroid
# centroid is the centre around which all the data points in that group gather (a centre of gravity)
# find the centriods, assign each observations/data points to these centroids
# recalculate the centroids, reassign the data points accordingly
# iterate back and forth until a sufficiently good solution is reached

# in K means clustering 3 items are needed:
            # a defined distance metric
            # number of clusters
            # initial guesses for cluster centroids

# often the initial centroids are picked randomly to start the algorithm

set.seed(2022 - (25+02))
par(mar=c(2,3,2,2))
x <- rnorm(12, mean = rep(1:3, each=4), sd=0.2)
y <- rnorm(12, mean = rep(c(1,2,1), each=4), sd = 0.2)
plot(x,y, col="green", pch=19, cex=2)
text(x+0.035, y+0.035, labels = as.character(1:12))

# once data points are assigned to the randomly initialized centroids, cluster centroids
# are recalculated, by finding the mean of coordinates of the data points in that cluster
# and the data points are reassigned accordingly to the newly determined centroids
# this process is reiterated 

dframe <- data.frame(x=x,y=y)

# the function kmeans() returns a k-means object
kmeans(dframe, centers = 4)
# this encompasses all the information needed to create the expected cluster

names(kmeans(dframe, centers = 4))
# [1] "cluster"      "centers"      "totss"        "withinss"     "tot.withinss"
# [6] "betweenss"    "size"         "iter"         "ifault"

# the most important element is the cluster element
kmeans(dframe, centers = 4)$cluster  # 2 1 1 2 3 3 3 3 4 4 4 4
# the cluster element has the labels for each 12 data points
# since we asked for 4 different clusters there are 4 different labels!

kmeans(dframe, centers = 4)$centers
# this returns the x,y coordinate pairs for the 4 centroids

kmobj <- kmeans(dframe, centers = 4)
plot(x,y, col=kmobj$cluster, pch=19, cex=2)
points(kmobj$centers, col=1:4, pch=4, cex=3, lwd=1.5)

# using heatmaps to visualize K-means clustering
x <- c(rnorm(10, m=3, sd = 0.25), rnorm(10, m=.5, sd = 0.79))
y <- rnorm(20, m=0, sd=7.5)
z <- rnorm(20)
dframe <- data.frame(x=x,y=y,z=z)
dmat <- as.matrix(dframe)

kmeans(dmat, centers = 5)
# this will do a k means clustering in 3 dimensions

x <- c(rnorm(10, m=3, sd = 0.25), rnorm(10, m=.5, sd = 0.79))
y <- rnorm(20, m=0, sd=7.5)
dframe <- data.frame(x=x,y=y)
dmat <- as.matrix(dframe)
plot(dmat, col="red", pch=16)
plot(hclust(dist(dmat)))

plot(dmat, col=kmeans(dmat, centers = 5)$cluster, pch=19)
points(kmeans(dmat, centers = 5)$centers, pch=4, lwd=2)

kmobj <- kmeans(dmat, centers = 5)
image(dmat) # heatmap is displayed horizontally
image(t(dmat)[, order(kmobj$cluster)])  
# transposing the matrix and ordering by cluster labels

# K means is a useful algorithm for organizing high dimensional data & looking for patterns
# number of clusters "centres" must be specified; 
          # pick by eye/intuition
          # pick by cross validation/information theory
          # pick by determining the number of clusters

# K means clustering is not deterministic
# since starting points are chosen randomly, it is best to run the kmeans algorithm a couple of times
# to make sure each iteration does not generate significantly different finishing points












