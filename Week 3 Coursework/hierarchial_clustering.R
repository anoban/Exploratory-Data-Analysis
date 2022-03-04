# a very intuitive technique for visualizing high dimensional data
# helpful to make sense of high dimensional data fairly quickly

# how do we find things that are "close"?
	# how do we define close?
	# how do we group things?
	# how do we visualize the groups?
	# how do we interpret groupings?

# hierarchial clustering is an agglomerative approach
# involves organizing data into hierarchies
# it is a bottom up approach
# starts with data as individual data points
# lumping them together into a cluster (the entire dataset is just one big cluster)

# the basic idea is to find the two closest points in the dataset and merge them together
# the merged point (not an actual point) can be thought as a new super point
# then the two original data points are removed (not literally, rather pushed underneath the super point)
# repeat this over and over again
# find the next two closest points and merge them together
# this will result in a tree that shows the hierarchy of in the relationships between the data points

# this approach requires two important things:
	# a distance metric - how do one calculates the distance between two points?
	# an approach for merging points - once you've figured out which points are closest, how do you merge them together?

# hierarchial clustering produces a tree, formally called a dendrogram
# that shows how the data points were merged together

# how do we define "close"?
# if the definition of "close" does not make sense in the context of problem at hand then what just happens is garbage in - garbage out

# there are three distance/similarity metrics that are commonly used in hierarchial clustering:
	# continuous - euclidean distance
	# continuous - correlation similarity
	# binary - manhattan distance

# a suitable distance/similarity metric must be chosen for the problem
# most familiar metric is euclidean distance: which is a linear distance between two points

# Euclidean distance

# take two cities; Baltimore & Washington D.C for example
# if these two cities are put on a map, centre of each city has  an x and y coordinates!
# a straight diagonal line could be drawn connecting the centres of the two cities
# then calculate the distance using Pythogorus theorem

# euclidean distance is a function of the difference between the x coordinates & the difference between the y coordinates
#   sqrt((x_1 - x_2)^2 + (y_1 - y_2)^2)  
# this is for one dimensional distances!

# in real world problems: like a bird/butterfly is to fly from Baltimore city to W.D.C they can fly straight since they are not interrupted
# by things like skycrapers,mountains,trees and you name it.

# Euclidean distance can easily be extended to multiple dimensions
# just take the difference between the data points along the n number of coordinates
# square the differences
# then take the square root

# Manhattan distance

# looks at data points on a grid
# in order to move from one point to another,
# assume having to move to the opposite corner of a square mesh grid:
	# one can move along the diagonal axis (the shortest distance) - not possible in a grid since one has to 
			# move through the grid lines
	# first move along the y axis upwards, then move right along the x axis
	# first move right along the x axis, then move upwards along the y axis
	# move in a haphazard zig-zag path
	
# Manhattan distance can be written formulaically as the absolute sum of all the different coordinates
# if we have two different coordinates x,y: sum the total absolute distance travelled in the x direction
# sum the total absolute distance travelled in the y direction
# |a_1 - a_2| + |b_1 - b_2| + |c_1 - c_2| + ............. + |z_1 - z_2|

# Manhattan distance can be very helpful is rather peculiar cases, like in city blocks where two points may
# seem close in Euclidean distance, but may be very far apart when one has to move along the blocks!
