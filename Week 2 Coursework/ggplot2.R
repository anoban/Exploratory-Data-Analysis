# grammar of graphics - ggplot2


# qplot() - works much like the plot() base R function
# looks for data in the dataframe / parent environment
# plots are made of aesthetics (size, shape, colour, .....) and geoms (points, lines .....)
# qplot() stands for quick plot!
# in ggplot the data has to be organized in a dataframe
# it is not mandatory to pass the data to ggplot via a dataframe
# if not so, ggplot will look for the data in the parent environment (global scope)
# factors are very important since they can be used to subset the data
# eg; a gender column in addition to the x,y variables say age and height
# factorized gender column can be used to subset the data, colour the data points differently
# it is also important to label the factor variables properly
library(tidyverse)
library(ggplot2)
data(mpg)  # for loading a dataset
str(mpg)
dim(mpg)  # 234 x 11 - the miles per gallon dataset

# displ - how large the engine is
# cyl - number of cylinders in the engine
# hwy - highway mileage
# drv - what kind of drive the vehicle is

mpg <- mpg %>% mutate(manufacturer = as.vector(manufacturer)) %>%
  mutate(cylinders = as.vector(cyl)) %>%
  mutate(drive = as.vector(drv)) %>%
  mutate(type = as.vector(class))

qplot(displ, hwy, data = mpg)
# unlike lattice system here the coordinate specification sequence is x,y (similar to base system)

# colouring based on drive types
qplot(displ, hwy, data = mpg, color = drive, size = 1)

# adding geoms to the plot
# smooth geom is the line of best fit, with 95% confidence interval in grey zone
# and the points geom is the actual data points 
qplot(displ, hwy, data = mpg, geom = c("point","smooth"))

# histograms
# passing just one variable to qplot() automatically generates a histogram 
qplot(hwy, data = mpg, fill = drive)
qplot(hwy, data = mpg, color = drive)

# facts 
# ggplot's facets are equivalent to lattice's panels
qplot(displ, hwy, data = mpg, facets = ~ drive, color = drive)  # scatter plot
qplot(hwy, data = mpg, fill = drive, facets = ~ drive, color = "black")  # histogram

# MAACS study data
load("D:\\R\\Exploratory_DS\\week_2\\maacs.Rda")
str(maacs)  
# str() gives a compact description of the R object

# pm25 - fine particulate matter
# eno - exhaled nitrous oxide
# mopos - mouse positive variable (a skin test to find whether the child is allergic to mouse allergen or not)

qplot(eno, data = maacs, geom = "histogram")
qplot(log(eno), data = maacs, geom = "histogram")
qplot(log(eno), data = maacs, geom = "histogram", fill = mopos)
qplot(log(eno), data = maacs, geom = "histogram", facets = ~ mopos, fill = mopos)

# smoothing
qplot(log(eno), data = maacs, geom = "density")
qplot(log(eno), data = maacs, geom = "density", fill = mopos, alpha = .5)
qplot(log(eno), data = maacs, geom = "density", color = mopos)

# scatter plots
qplot( log(pm25), log(eno), data = maacs, color = mopos, geom = "point", facets = ~ mopos)
qplot( log(pm25), log(eno), data = maacs, color = mopos, geom = "point", facets = ~ mopos, shape = mopos)

# adding a linear regression line
qplot(log(pm25), log(eno), data = maacs, color = mopos) +geom_smooth(method = "lm")
qplot(log(pm25), log(eno), data = maacs, color = mopos, facets = ~ mopos) +geom_smooth(method = "lm")

library(data)
data(airquality)

airquality = transform(airquality, Month = factor(Month))
qplot(Wind, Ozone, data = airquality, facets = . ~ Month)
qplot(Wind, Ozone, data = airquality, facets = . ~ factor(Month))

# basic ideas/fundamentals of ggplot
# basic components of a ggplot plot:
      # a data frame
      # aesthetic mapping: how the data is mapped to colour,size..
      # geoms: geometric objects like lines, points, shapes.....
      # facets: for conditional plots
      # stats: statistical transformations like binning, quantiles, smoothing
      # scales: what scale the aesthetic map uses
      # coordinate system


# in ggplot the plot can nbe built piece by piece i.e. layer by layer
# plot the data -> overlay a summary e.g smoother/regression line -> metadata and annotation

# studying the environmental triggers that affect asthma morbidity
# does BMI of children affect their vulnerability to asthma?
maacs_data <- read_csv(file = "https://raw.githubusercontent.com/rdpeng/artofdatascience/master/manuscript/data/bmi_pm25_no2_sim.csv", col_names = TRUE)

qplot(logpm25, NocturnalSympt, data = maacs_data, facets = ~ bmicat, color = bmicat)
# adding a regression line
qplot(logpm25, NocturnalSympt, data = maacs_data, facets = .~ bmicat, color = bmicat, geom = c("point","smooth"))
qplot(logpm25, NocturnalSympt, data = maacs_data, facets = .~ bmicat, color = bmicat, geom = c("point","smooth"), method = "lm")

# reconstructing the above plot layer by layer
mdata <- maacs_data[,c(1,3,4)]  # extracting the three needed columns

str(mdata)
plt <- ggplot(data = mdata, aes(x = logpm25, y = NocturnalSympt))
# this just creates the canvas with appropriate coordinate systems
# does not plot the datapoints inside the canvas
print(plt) # returns just an empty canvas

summary(plt)

# adding a points layer
plt + geom_point() # this does return a plot
# the ggplot object plt has all the information that the geom_point() call needs
# thus they do not need to be specified separately

plt + geom_point() + geom_smooth()
plt + geom_point() + geom_smooth(method = "lm")

# facetting by MBI category
plt + geom_point() + geom_smooth(method = "lm") + facet_grid(~ bmicat)

# number of subplots in the canvas will be determined by the number of levels in the factor passed
# as the facet criterion
# if we pass two factor variables to facet function; then the product of the number of levels in 
# those 2 variables will be the number of subplots in the canvas
# eg: facet_grid(var1 ~ var2)

# annotations
# labels - xlab(), ylab(), labs(), ggtitle()
# each layer has its own functions for annotation
# theme() is a global function, applies to all layers of the ggplot object
      # eg: theme(legend.position = "none")
# two standard appearance themes are included
      # theme_gray() - default
      # theme_bw()

plt + geom_point() + geom_smooth(method = "lm") + facet_grid(~ bmicat) +
  theme_bw()

# modifying aesthetics
plt + geom_point(color = "steelblue", size = 2.5) + geom_smooth(method = "lm") + facet_grid(~ bmicat)
plt + geom_point(aes(color = bmicat), size = 2.5) + geom_smooth(method = "lm") + facet_grid(~ bmicat)
plt + geom_point(aes(color = bmicat), size = 2.5, alpha = 0.3) + geom_smooth(method = "lm") + facet_grid(~ bmicat)

plt + geom_point(aes(color = bmicat), size = 2.5) + 
  geom_smooth(method = "lm") +   # the default smoothing method is loess, & lm specifies a linear model
  facet_grid(~ bmicat) +
  xlab(expression("log "*PM[2.5])) +
  ylab("Nocturnal Symptoms") +
  ggtitle("MAACS Cohort")

# smoothing is often necessary to shiw the  overall trend in the data!

plt + geom_point(aes(color = bmicat), size = 2.5) + 
  geom_smooth(method = "lm", size = 1.5, color = "red", linetype = 2) +  
  xlab(expression("log "*PM[2.5])) +
  ylab("Nocturnal Symptoms") +
  ggtitle("MAACS Cohort")

plt + geom_point(aes(color = bmicat), size = 2.5) + 
  geom_smooth(method = "lm", size = 1.5, color = "red", linetype = 2, se = FALSE) +  
  xlab(expression("log "*PM[2.5])) +
  ylab("Nocturnal Symptoms") +
  ggtitle("MAACS Cohort")

# se = FALSE removes the standard error: the gray zone of 95% confidence interval
# default font is Haveltica (A seriff font)

# changing the font style
# to change the font style, the desired font must be specified inside a theme function!
plt + geom_point(aes(color = bmicat), size = 2.5) + 
  geom_smooth(method = "lm", size = 1.5, color = "red", linetype = 2) +  
  xlab(expression("log "*PM[2.5])) +
  ylab("Nocturnal Symptoms") +
  ggtitle("MAACS Cohort") +
  theme_light(base_family = "Times")

# axes limits
test  <- data.frame(x = 1:100, y = rnorm(100))
test[c(34,86), 2] = c(21.87, 32.09) # introducing two outliers
plot(test$x, test$y, type = "l")

# constraining the range of y axis
plot(test$x, test$y, type = "l", ylim = c(-3,4))
# it is typical to limit the scope of the canvas to data points of interest, ignoring the outliers
# applying axes limits helps in this regard
# this allows us to socus on the trends in the data, without being distracted by noise (outliers)

ggplot(data = test, aes(x = x, y = y)) +
  geom_line()  # all data points are included
  

ggplot(data = test, aes(x = x, y = y)) +
  geom_line() +
  ylim(c(-3,3))
# unlike the base plotting sysytem that just tightens the canvas according to the specified limits
# ggplot removes the outlying data points that are outside the limits of the axis
# this results in an inconsistent plot with missing data points

# to include the outlier data points in the plot while restricting the area to specified axes limits
ggplot(data = test, aes(x = x, y = y)) +
  geom_line() +
  coord_cartesian(ylim = c(-3,3))
# this includes the outlier data points, just crop zooms the canvas within given limits

# how relationship between pm25 and nocturnal symptoms varies with BMI and no2
# however the no2 variable is continuous, not categorical
# thus it needs to be transformed into a categorical variable for subsetting

range(maacs_data$logno2_new)  # 0.3419452 2.1695374

data <- if (maacs_data$logno2_new >= 0.3419452 and maacs_data$logno2_new <= 1.2) {
  transform(maacs_data, no2_cat = "low")
  } else if (maacs_data$logno2_new > 1.2 and maacs_data$logno2_new <= 1.4) {
  transform(maacs_data, no2_cat = "medium")
  } else {transform(maacs_data, no2_cat = "high")}


# to categorize no2 concentration into 3 groups
# making no2 tertiles:
cut_points <- quantile(maacs_data$logno2_new, seq(0,1, length=4), na.rm = TRUE)

# cut() slices a vector according to the specifies ranges!
cut(maacs_data$logno2_new, cut_points)

# introducing a logno2_cat column as a categorical variable
no2_cat <- maacs_data %>% transform(logno2_cat = cut(maacs_data$logno2_new, cut_points))
levels(no2_cat$logno2_cat)  # 3 levels: "(0.342,1.23]" "(1.23,1.47]"  "(1.47,2.17]"

ggplot(no2_cat, aes(x = logpm25, y = NocturnalSympt)) +
  geom_point(size = 2, alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_grid(bmicat ~ logno2_cat) +
  xlab(expression("log "*PM[2.5])) +
  ylab("Nocturnal Symptoms") +
  ggtitle("MAACS Cohort") +
  theme_bw(base_family = "Avenir", base_size = 10)