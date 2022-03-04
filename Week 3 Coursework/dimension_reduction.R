# principal component analysis
# useful in both exploratory data analysis phase and formal modelling phase
# done in eight stages

# generating a random matrix data
set.seed(2022-(25+02))
par(mar=c(rep(0.2,4)))
dmatrix <- matrix(rnorm(400), nrow = 40)
image(t(dmatrix))
# the matrix heatmap plotted by this image() function is not particularly informative/impressive

# plotting the heatmap after hierarchical clustering
par(mar=c(2,2,1,1))
plot(hclust(dist(dmatrix))) # dendrogram after hierarchical clustering

heatmap(dmatrix) # heatmap which runs a clustering algorithm before mapping the data
# dendrograms shown for both rows and columns
# heatmap() function calls a clustering algorithm under the hood on both the rows and columns
# before mapping the data to the canvas

# intentionally adding a pattern to the data matrix
dim(dmatrix) # 40 x 10

for (i in 1:40) {
  # flip a coin
  result <- rbinom(1,size = 1, prob = 0.5)
  # if the result is head add a common pattern to that row
  if (result == 1) {
    dmatrix[i,] <- dmatrix[i,] + rep(c(0,3), each = 5)
    # adds 0,3,0,3,0,3,0,3,0,3 to the values of i th row in the dmatrix
  }
}

par(mar=(rep(0.2, each=4)))
image(1:10, 1:40, t(dmatrix)[, nrow(dmatrix):1])  # the range specifications are axes labels
# nrow() returns the number of rows in a matrix like object
# nrow():1 returns a descending integer sequence starting from the number of rows and ending with 1
# [, nrow(dmatrix):1] reorders the columns in descending order in the transposed matrix

# in the heat map left hand side has lighter colours; meaning that they have lower values in general
# right hand side has darker colours; meaning that they have relatively higher values

# running a hierarchical cluster analysis on the data matrix
heatmap(dmatrix)
# two sets of columns are clearly separated out
# the dendrogram on top  shows two main branches that has the sub-branches for each columns
# on the rows there is no obvious patters 

# patterns in rows and columns
hcluster <- hclust(dist(dmatrix))  # hierarchical clustering on the data matrix
ordered_rows <- hcluster$order # extracting the order element from the hclust object
sorted_dmat <- dmatrix[ordered_rows,] # creating a new matrix where rows are ordered by closeness 
# on the basis of hierarchical clustering.

par(mfrow= c(1,3), mar=c(4,4,1,1),oma=c(1,1,2,2))
image(t(sorted_dmat)[, nrow(sorted_dmat):1])
plot(x = rowMeans(sorted_dmat), y = 40:1, xlab = "Row means", ylab = "Rows", pch = 19, col = "purple")
plot(x = colMeans(sorted_dmat), ylab = "Column means", xlab = "Columns", pch = 19, col = "red")


# a slightly more formal approach to cluster analysis
# this takes advantage of the matrix structure of the data

# if there are lots of variables & creating a new set of variables that are uncorrelated helps explain as much 
# variance as possible
# if the dataset has 100s of variables, in reality these are not independent measurements of something
# a lot of them may be related to each other / correlated to each other

# the idea is to create a smaller set of variables, that are all uncorrelated with each other
# that these variables represent different types of variations in the dataset
# reducing the number of such uncorrelated variables will help explain as much variability as possible in the 
# dataset
# put all the variables together in one matrix, and find the best matrix created with fewer variables that
# still explains the original data
# in technical terms find a lower rank matrix that explains the orifinal data reasonably well

# first goal: PCA - principal component analysis
# second goal: get a smaller abstraction of the data - data compression - via SVD - singular value decomposition


# SVD - Singular Value Decomposition

# take a matrix X with variables in columns and observations in rows
# then the SVD is a matrix decomposition
# matrix decomposition decomposes the matrix into 3 separate matrices: U,D & V
# X = UDV^T
# columns of U are orthogonal: independent of each other (left singular vectors)
# columns of V are also orthogonal (right singular vectors)
# D is a diagonal matrix that contains singular values


# PCA - Principal Component Analysis

# basic idea is to take the data of original matrix, subtract the mean of each column from each column
# and then divide by the standard deviation of each column
# and then run a singular value decomposition
# which is essentially re-normalizing the original data matrix
# Principal components will be equal to the right singular values - the V matrix


# Components of SVD
scale(sorted_dmat)  # scale() is basically Z values: subtract the mean and divide the result by standard deviation
svd(scale(sorted_dmat)) # returns three matrices
                        # d - one dimensional array (vector)
                        # u and v are two dimensional arrays (matrices)

svd_sorted_dmat <- svd(scale(sorted_dmat))
par(mfrow=c(1,3), mar=c(4,4,1,1),oma=c(1,1,2,2))
# t() transposes the matrix: columns become rows and vice versa
# [, nrow():1] reverses the order of columns
image(t(sorted_dmat)[,nrow(sorted_dmat):1])
plot(x = svd_sorted_dmat$u[,1], y = 40:1, xlab = "Rows", ylab = "First left singular vector", pch = 19)
plot(x = svd_sorted_dmat$v[,1], xlab = "Columns", ylab = "First right singular vector", pch = 19)


# Variance explained
par(mfcol=c(1,2), mar=c(4,4,1,1),oma=c(1,1,2,2))
# plotting the raw singular values
# does not have much meaning since its not on an interpretable scale
plot(x = 1:length(svd_sorted_dmat$d), y = svd_sorted_dmat$d, xlab = "Column", ylab = "Singular value", pch=19)
# dividing by the sum of squares of d translates singular values to an interpretable scale
plot(x = 1:length(svd_sorted_dmat$d), svd_sorted_dmat$d^2/sum(svd_sorted_dmat$d^2), xlab="Column", ylab="Proportion of Variance Explained", pch=19)

# another component of SVD is the Variance explained; which comes from the D matrix
# D matrix contains the singular values
# It is a diagonal matrix: that only has elements that are on the diagonal of the matrix
# each singular value represents the percent of total variation explained by that particular component
# components are typically ordered so that the first one has the most variation and the last one with
# the lowest variation.


# Relationship between PCA & SVD
svd_matrices <- svd(scale(sorted_dmat))
pca_matrices <- prcomp(sorted_dmat, scale. = TRUE)
par(mfrow=c(1,1), mar=c(4,4,1,1), oma=c(1,1,1,1))
plot(x = pca_matrices$rotation[,1], y = svd_matrices$v[,1], xlab = "Principal component 1", ylab = "First right singular vector", pch=19)
abline(c(0,1), col="red", lwd=1.25)
# here the first right singular vector & first principal component fall exactly on the same places

# SO SVD & PCA ARE ESSENTIALLY SAME

# Variance Explained D matrix of SVD!
mat_zeros <- matrix(data = 0,nrow = 40, ncol = 10)
for (x in 1:dim(mat_zeros)[1]) {
  mat_zeros[x,] <- rep(c(0,1), each=5)
}

svd_mat <- svd(mat_zeros)
# since the values of this matrix are identical column wise, and are just 0s and 1s scaling is not necessary
par(mfrow=c(1,3), mar=c(4,4,1,1), oma=c(1,1,1,1))
image(t(mat_zeros)[,nrow(mat_zeros):1])
plot(svd_mat$d, xlab = "Column", ylab = "Singular value", pch=19)
plot(svd_mat$d^2/sum(svd_mat$d^2), xlab = "Column", ylab = "Proportion of variance explained", pch=19)

# in this matrix the first five columns are zeros and the second five columns are ones
# when considering the singular values (d matrix) first singular value is high and the remainders are almost 0
# first singular value explains 100% of the variation in the matrix
# eventhough this matrix has 40 rows and 10 columns there is just one dimension to this matrix in terms of variation
# if in first five columns; mean = 0
# if in the second five columns; mean = 1
# this variation is captured by the first singular value: that shows 100% of the variance in the dataset

# adding a new pattern
set.seed(2022-(27+2))
for (i in 1:nrow(mat_zeros)) {
  toss_1 <- rbinom(n=1, size = 1, prob = 0.5)
  toss_2 <- rbinom(n=1, size = 1, prob = 0.5)
  if (toss_1 == 1) {mat_zeros[i,] <- mat_zeros[i,] + rep(c(0,5), each=5)} # adding 0,0,0,0,0,5,5,5,5,5 to the i th row values 
  if (toss_2 == 1) {mat_zeros[i,] <- mat_zeros[i,] + rep(c(0,5), 5)}  # adding 0,5,0,5,0,5,0,5,0,5 to the i th row values
}

hier <- hclust(dist(mat_zeros))
# rearranging the rows of the matrix based on closeness
ordered_mat <- mat_zeros[hier$order,]
scaled_mat <- scale(ordered_mat)  # NaNs introduced for zero variance columns
scaled_mat[is.nan(scaled_mat)] <- 0 # replacing NaNs with zeros
omat_svd <- svd(scaled_mat)

par(mfrow=c(1,3), mar=c(4,4,1,1), oma=c(1,1,1,1))
image(t(ordered_mat)[,nrow(ordered_mat):1])
plot(rep(c(0,1), each=5), ylab="Pattern 1", xlab = "Column", pch=19)
plot(rep(c(0,1), 5), ylab="Pattern 2", xlab = "Column", pch=19)

# in the middle plot the first 5 columns have a lower mean  and the second five columns
# have relatively higher means
# the third plot shows an alternating oscillation in the means
# we rarely know these patterns for real world data unlike for synthetic data
# we need to learn these patterns when analyzing real world data
# thus SVD helps to expose the patterns buried in the datasets

par(mfrow=c(1,4), mar=c(4,4,1,1), oma=c(1,1,1,1))
image(t(ordered_mat)[,nrow(ordered_mat):1])
plot(rep(c(0,1), each=5), ylab="Pattern 1", xlab = "Column", pch=19, col="magenta")
plot(rep(c(0,1), 5), ylab="Pattern 2", xlab = "Column", pch=19, col="red")
plot(colMeans(t(ordered_mat)[,nrow(ordered_mat):1]), ylab="Column mean", xlab = "Column", pch=19, col="blue")


# V matrix and patterns of variance in rows

par(mfrow=c(1,3), mar=c(4,4,1,1), oma=c(1,1,1,1))
image(t(ordered_mat)[,nrow(ordered_mat):1])
plot(omat_svd$v[,1], pch=19, xlab = "Column", ylab = "First Right singular vector")
plot(omat_svd$v[,2], pch=19, xlab = "Column", ylab = "Second Right singular vector")


# D matrix and the variance explained
par(mfrow=c(1,2), mar=c(4,4,1,1), oma=c(0,0,0,0))
plot(omat_svd$d, xlab = "Column", ylab = "Singular value", pch=19, col="blue")
plot(omat_svd$d^2/sum(omat_svd$d^2), xlab = "Column", ylab = "Proportion of variance explained", pch=19, col="red")

# in the right panel: percent of variance explained is shown
# the first singular value explains roughly 80 % of total variation in the data set
# that is because of the shift pattern in first 5 and second 5 columns 
# caused by + rep(c(0,5), each=5)
# this shift pattern is so strong that it represents the largest amount of variation in the dataset
# the second singular value captures roughly 20 % of the total variation


# Dealing with missing values 
# mat_zeros have 0s in many columns and certain columns containing all zeroes
mat_zeros[sample(1:100, size=40, replace = FALSE)] <- NA
# samples 40 random numbers from the range 1:100 without replacement
# then replaces the values of matrix at those indices with NA
sum(is.na(mat_zeros)) # 40 - voila!

svd(scale(mat_zeros))
# Error in svd(scale(mat_zeros)) : infinite or missing values in 'x'
# a major issue with svd() or prcomp() is missing values
# a real data set will almost always have missing values unlike synthetic datasets
# svd() and prcomp() algorithms cannot run on datasets with missing values
# one way is to introduce a value into these missing indices using KNN predictor
# this will find the KNN of the missing space and replace the NA with the mean of KNN 


# Face example
# a face is represented by a colour matrix
load("D:\\R\\Exploratory_DS\\week_3\\face.Rda")
image(faceData) # face is oriented horizontal
image(t(faceData)) # face has become vertical but upside down
image(t(faceData)[,nrow(faceData):1]) # alright

svd_face <- svd(scale(faceData))
plot(svd_face$d^2/sum(svd_face$d^2), xlab = "Singular values", ylab = "Variance Explained", pch=19, col="red")
# first singular value explains about 40 % of the total variation
# second singular vector explains about 24 % of the total variation
# third singular vector explains about 15 % of the total variation

# examining the images generate by the first five singular vectors
# using the matrix multiplication operator %*%
length(svd_face$d)  # 32
svd_face$d[1] # first singular value 19.77887

approx_1 <- svd_face$u[,1] %*% t(svd_face$v[,1]) * svd_face$d[1]
# multiplying first column of left singular vector by first column of the transpose of right singular 
# vector
# the resulting matrix is then multiplied by first singular value


# making diagonal matrices from d
# a square matrix is called a diagonal matrix when all entries outside the diagonal axes are zeroes
approx_5 <- svd_face$u[,1:5] %*% diag(svd_face$v[,1:5]) %*% svd_face$d[1:5] # first five singular values
approx_10 <- svd_face$u[,1:10] %*% diag(svd_face$v[,1:10]) %*% svd_face$d[1:10] # first ten singular values
 
par(mfrow =c(1,4), mar=c(4,4,1,1), oma=c(1,1,1,1))
image(t(approx_1)[,nrow(approx_1):1], main="(A)")
image(t(approx_5)[,nrow(approx_5):1], main="(B)")
image(t(approx_10)[,nrow(approx_10):1], main="(C)")
image(t(faceData)[,nrow(faceData):1], main="Face")

# when moving left to right along the panels; the picture is supposed to become gradually more conspicuous
# not so much here :(
# this is an example of data compression approach that SVD can generate













