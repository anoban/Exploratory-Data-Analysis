set.seed(2022 - (24+02))
par(mar = c(0,0,0,0))
x <- rnorm(12, mean = rep(1:3, each =  4), sd = 0.2)
y <- rnorm(12, mean = rep(1,2,1, each =  4), sd = 0.2)
plot(x,y, pch = 19, col = "blue", cex = 2)
text(x + 0.02, y - 0.02, labels = as.character(1:12)) # annotation

# running the hierarchical clustering algorithm

dframe <- data.frame(x = x,y = y)
dist(dframe)
# dist() takes a data frame or a matrix and calculates the distances between all the different rows
# and returns the distance matrix: which shows all the pair wise distances!
# by default the distance is calculated based on Euclidean distance metric
# but the metric can be provided to the dist() call to override the defaults

for(i in 1:12){print(sqrt((dframe[i,][1] - dframe[i+1,][1])^2 + (dframe[i,][2] - dframe[i+1,][2])^2))}
# this gives the first diagonal line of distances in the distance matrix returned by the dist() function

for(i in 1:12){print(sqrt((dframe[i,][1] - dframe[i+2,][1])^2 + (dframe[i,][2] - dframe[i+2,][2])^2))}
# this gives the second diagonal line of distances in the distance matrix returned by the dist() function

for(i in 1:12){print(sqrt((dframe[i,][1] - dframe[i+3,][1])^2 + (dframe[i,][2] - dframe[i+3,][2])^2))}
# this gives the first diagonal line of distances in the distance matrix returned by the dist() function

# so on and so forth
# the matrix returned by dist() is a lower triangular matrix
# it gives all the pair wise distances: square root of the sum of distances along x,y coordinates
# for all possible unique pairs of data points!

# finding out the two points that are closest to each other
min(dist(dframe))  # 0.1900592
which(dist(dframe) == min(dist(dframe)), arr.ind = TRUE)  # 39

# 39 th value in the distance matrix corresponds to the distance between 6th and 5th rows (records)
par(mar=c(0,0,0,0))
plot(x,y, pch = 19, col = "green", cex = 2)
text(x + 0.03,y, labels = as.character(1:12))
points(x = dframe$x[c(5,6)], y = dframe$y[c(5,6)], pch = 19, col = "red")  # colour coding the closest data points red

order(dist(dframe), decreasing = FALSE)
# getting the indices of the elements in dist(dframe) object, with an ascending order
# [1] 39  3 63 65 66 47 62 52 55 12 64 22  1 41  2 31 61 53 13 32 56 46  4 23 59 54  5 40 57 24 34 60 50
# [34] 14  7 58 48 15 44 26 33 51 42 49  6 45 17 25 43 37 35 10 16 38  8 29 36 11 27 30 20  9 28 18 21 19

dist(dframe)[3] # 0.1918391

par(mar=c(0,0,0,0))
plot(x,y, pch = 19, col = "#1BFFC1", cex = 2)
text(x + 0.03,y, labels = as.character(1:12))
points(x = dframe$x[c(5,6)], y = dframe$y[c(5,6)], pch = 19, col = "red")  # colour coding the closest data points red
points(x = dframe$x[c(1,4)], y = dframe$y[c(1,4)], pch = 19, col = "blue") # second closest points

# hclust() function creates a dendrogram object using the distance matrix
par(mar=c(2,3,2,2))
hclust(dist(dframe))
plot(hclust(dist(dframe)))

# the data points that were clustered first are at the bottom of the dendrogram
# and the data points that were clustered later (merged super points) are positioned higher in the 
# dendrogram

# depending on where one looks, the number of clusters in a dendrogram may vary!
# it comes down to where one wants to slice the dendrogram horizontally!
par(mar=c(2,3,2,2))
plot(hclust(dist(dframe)))
abline(h=2, lty="dotted", col = "red", lwd=2)
# above this red line there are just two main clusters

par(mar=c(2,3,2,2))
plot(hclust(dist(dframe)))
abline(h=1.4, lty="dotted", col = "red", lwd=2)
# below this red line there are three main clusters

par(mar=c(2,3,2,2))
plot(hclust(dist(dframe)))
abline(h=0.7, lty="dotted", col = "red", lwd=2)
# below this red line there are four main clusters

par(mar=c(2,3,2,2))
plot(hclust(dist(dframe)))
abline(h=.45, lty="dotted", col = "red", lwd=2)
# below this red line there are six main clusters

# so it is important to cut the tree at a level that is appropriate to the data and purpose

# better looking dendrograms





















# merging data points

# when merging two data points what becomes the coordinate of the new super point?
# what is the exact location of the super point resulting from the merger?

# not really considering the merger of two data points, but the merger of two clusters   
    # one method of merger is the average linkage
    # here the coordinates of the new data point is the average of the x,y coordinates of parent data points
    
    # next method of merger is called a complete linkage
    # here the distance between two clusters of data points is measured
    # take the farthest two points from two clusters
    # the distance between those two clusters is equal to distance between the two farthest points in those clusters

# the resulting distance is generally greater when the complete method is used compared to the average method
# these two methods can produce very different results; thus it is better to try and find out which one is appropriate for
# the problem setting at hand


# heatmap()

# a really nice function to visualize matrix data
# for an extremely large table/large matrix of numbers
# heatmaps help to take a quick look at them in an organized way
# heatmap() function essentially runs a hierarchical cluster analysis on the rows & columns of the data passed 
# to the function 
# rows of the tables are generally observations/records 
# columns of the tables are generally a set of observations belonging to specific categories (variables)

# heatmap() organizes the rows and columns of the dataframe in order to make the visualizing easier
# this organization is done through hierarchical clustering

heatmap(as.matrix(dframe))
# the cluster dendrogram is shown on the right: the same dendrogram plot(hclust(data)) returns
# since there are just two columns, two clusters are shown for columns

# hierarchical clustering organizes high dimensional data in a logical & intuitive way
# defining what is considered "close" between two points is important
# a merging strategy is essential
# in hierarchical clustering the clustering picture may be unstable
# removal of outliers/noise could change the cluster dendrogram significantly
# it is deterministic: no randomness
# clustering algorithms are sensitive to the scaling: variables measured in different units can easily throw off the algorithm
# choosing where to cut the dendrogram can be difficult
# must be used primarily for exploratory purposes

