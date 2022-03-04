# understanding human activity with smartphones
# Samsung dataset - Galaxy S2 phones
# using the accelorometer & gyroscope of the mobile phones

library(tidyverse)
library(gridExtra)
load("D:/R/Exploratory_DS/week_4/samsungData.rda")
names(samsungData) # 563 columns

table(samsungData$subject, samsungData$activity)
# 4 different types of movement:
              # laying 
              # sitting 
              # standing 
              # walk 
              # walkdown 
              # walkup
# 30 different subjects! 1:30

length(names(samsungData))
# 563
length(unique(names(samsungData)))
# 479

subject1 <- samsungData %>% subset(subject == 1) %>%
  transform(activity = as.factor(activity))
dim(subject1) # 347 563

# plotting the average acceleration of the subject1
par(mfrow=c(1,2), mar=c(5,4,1,1), oma=c(1,1,1,1))
plot(subject1$`tBodyAcc.mean...X`,  col=subject1$activity,
     ylab = "Mean body acceleration on X axis", xlab = "Index", pch=19)
plot(subject1$`tBodyAcc.mean...Y`, col=subject1$activity, 
     ylab = "Mean body acceleration on Y axis", xlab = "Index", pch=19)
legend("bottomright", legend = unique(subject1$activity),
       pch = 19, col = subject1$activity)
# for certain activities there are no meaningful difference in the acceleration on
# X axis
# on the other hand no activities show any noticeable variation in the Y 
# axis


p1 <- ggplot(data = subject1, aes(y=`tBodyAcc.mean...X`, x=1:length(`tBodyAcc.mean...X`),
                            color = activity))+
  geom_point(size=3)+
  ylab("Mean body acceleration on X axis")+
  xlab("Index")+
  theme(legend.position = "None")


p2 <- ggplot(data = subject1, aes(y=`tBodyAcc.mean...Y`, x=1:length(`tBodyAcc.mean...Y`),
                            color = activity))+
  geom_point(size=3)+
  ylab("Mean body acceleration on Y axis")+
  xlab("Index")+
  theme(legend.position = "bottom")
grid.arrange(p1,p2, ncol=2)

# there is not much variability in sedentary activities like laying, standing
# and sitting
# but there is significant variability in mobile activities like walking, walking up 
# and walking down



# running a hierarchical clustering on the first 3 columns
# mean accelerations on X,Y & Z axes
par(mfrow=c(1,1))
hclustered <- hclust(dist(subject1[,1:3]))
plot(hclustered)

colnames(subject1[,1:3]) <- c("X axis","Y axis","Z axis")
par(mar=c(0,0,0,0),oma=c(0,0,0,0))
heatmap(as.matrix(subject1[,1:3]), keep.dendro = TRUE, margins = c(10,5))

#' plclust in colour
#' 
#' Modifiction of plclust for plotting hclust objects in *in colour*!
#' 
#' @param hclust hclust object
#' @param labels a character vector of labels of the leaves of the tree
#' @param lab.col colour for the labels; NA=default device foreground colour
#' @param hang as in \code{\link{hclust}} & \code{\link{plclust}}
#' @param xlab title for x-axis (defaults to no title)
#' @param sub subtitle (defualts to no subtitle)
#' @param ... further arguments passed to \code{\link{plot}}
#' @author Eva KF Chan
#' 
#' @examples
#' data(iris)
#' hc <- hclust( dist(iris[,1:4]) )
#' myplclust(hc, labels=iris$Species,lab.col=as.numeric(iris$Species))
#' 
#' 
myplclust <- function( hclust, labels=hclust$labels, lab.col=rep(1,length(hclust$labels)), hang=0.1, xlab="", sub="", ...){
  ## modifiction of plclust for plotting hclust objects *in colour*!
  ## Copyright Eva KF Chan 2009
  ## Arguments:
  ##    hclust:    hclust object
  ##    lab:        a character vector of labels of the leaves of the tree
  ##    lab.col:    colour for the labels; NA=default device foreground colour
  ##    hang:     as in hclust & plclust
  ## Side effect:
  ##    A display of hierarchical cluster with coloured leaf labels.
  y <- rep(hclust$height,2)
  x <- as.numeric(hclust$merge)
  y <- y[which(x<0)]
  x <- x[which(x<0)]
  x <- abs(x)
  y <- y[order(x)]
  x <- x[order(x)]
  plot( hclust, labels=FALSE, hang=hang, xlab=xlab, sub=sub, ... )
  text( x=x, y=y[hclust$order]-(max(hclust$height)*hang), labels=labels[hclust$order], col=lab.col[hclust$order], srt=90, adj=c(1,0.5), xpd=NA, ... )
}

par(mar=c(3,4,3,0),oma=c(0,0,0,0))
myplclust(hclustered, lab.col = unclass(subject1$activity))

# clustering is quite messy
# and there is no discernible patterns in this cluster dendrogram

# maximum acceleration of the first subject

par(mfrow=c(1,2), mar=c(4,4,1.5,1.5), oma=c(1,1,0,0))
plot(subject1$fBodyAcc.max...X, col=subject1$activity, xlab="Index",
     ylab = "Maximum acceleration in X axis", pch=19)
plot(subject1$fBodyAcc.max...X, col=subject1$activity, xlab="Index",
     ylab = "Maximum acceleration in Y axis",pch=19)

# similar to mean accelerations; maximum accelerations also show significant variations
# for mobile activities like walking,  walking up & walking down
# sedentary activities like standing, laying & sitting do not show significant variations 
# in maximum acceleration just like mean accelerations 


# hierarchical clustering based on maximum acceleration
par(mfrow=c(1,1), mar=c(2,4,4,2))
myplclust(hclust(dist(subject1[,10:12])), lab.col = unclass(subject1$activity))
# hierarchical clustering based on maximum accelerations clearly clusters the 
# movements into two categories:
        # mobile activities
        # sedentary activities

# SVD 
svd_sub1 <- svd(scale(subject1[,-c(562:563)]))
par(mfrow=c(1,2), mar=c(4,4,2,2))
plot(svd_sub1$u[,1], col=subject1$activity, pch=19,
     ylab = "First left singular vector")
plot(svd_sub1$u[,2], col=subject1$activity, pch=19,
     ylab = "Second left singular vector")

# first left singular vector separates out the moving from the non-moving activities
# second left singular vector is more/less vague but separates the magenta colour really well

# hierarchical clustering with maximum contributor
# which.max(), which.min() return the indices of maximum and minimum values of a 
# numeric vector
# finding the index of maximum value in the second right singular vector
ind_max_scnd_rsv <- which.max(svd_sub1$v[,2])

# this includes the column index equal to the index of maximum contributor in 
# second right singular vector in addition to 10th,11th & 12th columns
subject1[,c(10:12,ind_max_scnd_rsv)] 
# `fBodyAcc.meanFreq...Z` 
# this maximum contributor is the mean body acceleration in the Z axis in the frequency domain


par(mfrow=c(1,1), mar=c(1,4,4,1), oma=c(0,0,0,0))
distMat <- dist(subject1[,c(10:12,ind_max_scnd_rsv)])
myplclust(hclust(distMat), lab.col = unclass(subject1$activity))

# this dendrogram separates all the three mobile activities very clearly
# yet the clustering of sedentary activities are not properly grouped

# K-means clustering
# can specify centres to 6 since we already know there are 6 different movement types
# leaving out the last two columns since they are categorical variables not numeric variables
# subject & sctivity

kmClust <- kmeans(subject1[,-c(562,563)], centers = 6)
str(kmClust)
# to see the distribution of activity labels after K-means clustering
table(kmClust$cluster, subject1$activity)
# all the mobile activities are grouped in separate clusters accurately
# cluster 1 - laying, sitting & standing
# cluster 2 - laying & sitting
# cluster 3 - laying, sitting & standing
# cluster 4 - strictly walking
# cluster 5 - strictly walking up
# cluster 6 - strictly walking down
# sedentary activities are non-uniformly distributed among the first three clusters

# K-means clustering can return very different answers depending on the times the algorithm is run
# and the starting points
# at the start one has to start the algorithm by specifying where the cluster centres are
# default behaviour is randomly selection of starting points
# selecting a random starting point may end up in suboptimal results
# generally it is better to pass a number higher than 1 for the nstart argument
# which will start the algorithm with more than one starting points which will]
# result in better optimization

# re running the K-means algorithm
kmClust <- kmeans(subject1[,-c(562,563)], centers = 6)
table(kmClust$cluster, subject1$activity)

# trying to start the algorithm with 100 different starting values and taking optimum solution
# from these 100 
kmClust <- kmeans(subject1[,-c(562,563)], centers = 6, nstart = 100)
table(kmClust$cluster, subject1$activity)
# this gives a very slightly better clustering but the sedentary activities are still
# distributed among different clusters; not separated into distinct clusters

# fourth cluster contains observations only for laying
dim(kmClust$centers) # 6 x 561

kmClust$centers[4,] # picking the 4th row of the centres table that corresponds to the 4th cluster
# picking just the first 25 elements 
par(mar=c(4,4,1,1))
plot(kmClust$centers[4,1:25], col="red", ylab = "Cluster centres", xlab = "", pch=19)
# notice the distribution of data points along the Y axis

# 6th cluster has observations only for walking
plot(kmClust$centers[6,1:25], col="blue", ylab = "Cluster centres", xlab = "", pch=19)
# notice the distribution of data points along the Y axis
# cluster centres are more/less symmetrically distributed on either sides of y = 0 line
