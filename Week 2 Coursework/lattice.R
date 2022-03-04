library(tidyverse)

# useful for plotting high dimensional data and making many plots at once
# implemented in the lattice package
# the package lattice contains code for producing Trellis graphs that are independent of the base graphics
# sysytem. 
# lattice package includes plotting functions like xyplot(), bwplot() & levelplot()
# lattice package is built on top of the grid package
# lattice plotting sysytem does not have a two step plotting process: plotting, followed by annotations!
# both plotting & annotation are done in a single plotting functions

# lattice functions:
 # xyplot() - scatter plots
 # bwplot() - box-and-whiskers plots
 # histogram() - histograms
 # stripplot() - boxplot with actual data points
 # dotplot() - plots dots on violin strings
 # splom() - scatter plot matrix: like pairs() in base plotting system
 # levelplot(), contourplot() - for plotting image data
 
# xyplot()
# syntax is xyplot(y ~ x | f*g, data)
# here the tilda "~" separates y and x variables
# variable on the left side of ~ is y variable
# variable on the right side of ~ is x variable
# f,g are conditioning categorical variables (optional)
# data is the dataframe to look for the variables

library(lattice)
library(datasets)

xyplot(Ozone ~ Wind, data = airquality)

# facetting in lattice
airquality <- transform(airquality, Month = factor(Month))
# converts Month into a categorical variable

xyplot(Ozone ~ Wind | Month, data = airquality)
# 5 subplots are created for each month
xyplot(Ozone ~ Wind | Month, data = airquality, layout=c(1,5))
# 5 subplots one above another
xyplot(Ozone ~ Wind | Month, data = airquality, layout=c(5,1))
# 5 subplots side by side

# a key difference between the lattice & base graphics systems is that lattice
# plotting functions do not actually plot anything!
# they just return a object belonging to the class "Trellis"
# base plotting functions plot the data directly to a graphics device: scree/pdf/png...
# print() method of lattice functions is what that actually plots the data to a graphics device
# lattice functions return a Trellis object that can actually be stored!
# it is still better to store the code and data instead of the Trellis object
# on command line the Trellis object is auto printed; so it appears as the lattice function itself is 
# printing the data


path <- "D:\\Python Developers Survey 2020 external sharing-20211207T130330Z-001\\Python Developers Survey 2020 external sharing\\2020_sharing_data_outside.csv"
data <- read.csv(path, sep = ",", header = TRUE)
python_v <- as_tibble(table(data$python3.version.most), .name_repair = "minimal")

trellis <- histogram(as.factor(data$ide.main))
class(trellis) # "trellis"
print(trellis)


library(nlme)
library(lattice)
xyplot(weight ~ Time | Diet, BodyWeight, layout = c(3,1))

# lattice package has panel functions
# lattice has defaults for these panel functions, but these are customizable
# panel functions take x,y coordinates of the data points 
# each panel is going to represent a subset of the data, defined by the conditioning variable 

set.seed(10) 
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x + f - f * x + rnorm(100, sd = 0.5)
f <- factor(f, labels = c("Group 1", "Group 2"))
xyplot(y ~ x | f, layout = c(2,1))
# group 1 looks like a strong linear relationship

# custom panel functions

xyplot(y ~ x |f, layout = c(2,1), panel = function(x,y,...){ # ... accommodates any other function that may get called
        panel.xyplot(x, y, ...) # first call in the default panel function for xyplot()
        panel.abline(h = median(y), lty = 2) # add a horizontal line at the median
})

xyplot(y ~ x |f, layout = c(2,1), panel = function(x,y, ...){
        panel.xyplot(x,y,...)
        panel.lmline(x,y, col="red") # adding a regression line
})

# multi panel lattice pots
# using the MAACS data - Mouse Allergen and Asthma Cohort Study
load(file = "D:\\R\\Exploratory_DS\\week_2\\maacs.Rda")
house_id <- rep(c("House 1","House 2","House 3","House 4","House 5"), 150)
maacs <- maacs %>% mutate(house_id = factor(house_id)) %>% 
        mutate(eno = as.numeric(eno)) %>%
        mutate(duBedMusM = as.numeric(duBedMusM)) %>%
        as_tibble()


