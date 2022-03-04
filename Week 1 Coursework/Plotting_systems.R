# R has three key plotting systems

# base plotting system - artist palette model
# uses a plot() function
# annotation functions to add text, lines, points, axis
# cannot remove objects once added

library(datasets)
with(cars, plot(speed,dist))


# lattice system
# every plot is constructed with a single function call
# best for conditioning plots
# to see how x,y vary when conditioned to a range of z values
# once created cannot add anything to the plot
# needs the library lattice

library(lattice)
xyplot(pm25 ~ longitude, data=pollution )

# base plotting system uses a artist's palette model
# lattice system uses a single function to make the whole plot, best for conditioning
# ggplot mixes the functions of base and lattice systems
# lattice plots are also called panel plots

# these systems cannot be mixed  (functions from these namespaces are not interchangeable)
library(tidyverse)
lifeEXP <- read_csv("D:\\R\\Life_Expectancy_Data.csv", col_names = TRUE)
developed <- lifeEXP %>% filter(Status=="Developed") 
xyplot(`Life expectancy`~ Year | Country, data = developed)  # lattice plotting
