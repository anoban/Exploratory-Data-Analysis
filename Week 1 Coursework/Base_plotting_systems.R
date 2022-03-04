# all core plotting functions of R's built-in plotting package are encapsulated in the graphics, grDevices packages
# graphics package contains base plotting functions like plot(), hist(), boxplot()..etc
# grDevices package contains codes implementing graphing devices: x11,pdf,PNG,postscript...etc

# lattiice plotting system is implemented through following packages
# lattice package: contains code for producing trellis graphics that are independent of the base graphing system
# this includes xyplot(), bwplot(), levelplot()...etc
# grid package: lattice package builds on top of the grid package
# it is rarely used directly; a lower level plotting system

# base plotting is done in two phases
# first step - initialize the plot eg: plot()/hist()
# second step - annotate to an existing plot eg: 

library(tidyverse)
lifeEXP <- read_csv("D:\\R\\Life_Expectancy_Data.csv", col_names = TRUE)
hist(lifeEXP$`Adult Mortality`)  # using the base plotting system
plot(lifeEXP$Year, lifeEXP$Population)  # scatter plots
plot(lifeEXP$Alcohol, lifeEXP$`Adult Mortality`)
lifeEXP <- lifeEXP %>% mutate(Year = factor(Year))  # making the year variable a categorical variable
boxplot(lifeEXP$`Adult Mortality` ~ lifeEXP$Year, xlab="Year", ylab="Population")

# keyword arguments used in base plots
# pch (plotting character) - plotting symbol, the default is open circle
US <- lifeEXP %>% filter(Country == "United States of America")
plot(US$Alcohol, US$`Adult Mortality`, pch="A") # "A" is used as plotting symbol
plot(US$Alcohol, US$`Adult Mortality`, pch="*")
plot(US$Alcohol, US$`Adult Mortality`, pch="#")
plot(US$Alcohol, US$`Adult Mortality`, pch="@")

# lty (linetype) - type of line, default is solid line
plot(US$Alcohol, US$`Adult Mortality`)
par(pch="+", lty="solid", lwd=2) # adds specific parameters to the plot

# lwd (linewidth)
# col (colour)
# xlab, ylab - axes labels

# once the annotation functions are activated these keyword arguments apply to all 
# the plot() calls following that instantiation

path <- "D:\\GPS_DATA\\Movement of long-tailed ducks marked on the Yukon-Kuskokwim Delta, Alaska 1998-2000 (data from Petersen et al. 2003).csv"
duck <- read_csv(path, col_names = TRUE)
unique(duck$`individual-local-identifier`)
duck00311 <- duck %>% filter(`individual-local-identifier`=="966-00311")
plot(duck00311$`argos:lon1`,duck00311$`argos:lat1`)

duck %>% ggplot(aes(x=`argos:lon1`, y=`argos:lat1`, color = `individual-local-identifier`))+
  geom_point(size=2)+
  geom_line()

# factor(var1) converts the variable var1 into a categorical variable
# par() specifies global plotting parameters!!!
# thus these affect all graphics in the given R session
# these parameters can be overridden by specifying the parameters inside each graphing
# calls! locally
# but a few are global graphing parameters that can only be changed using the par() function!

# las - orientation of axes labels
# bg - background colour
# mar - margin size
# oma - outer margin size
# mfrow - number of plots per row
# mfcol - number of plots per column

# checking the defaults for par()
par("pch")  # 1
par("lty")  # "solid"
par("lwd")  # 1
par("col")  # "black"
par("mar")  # 5.1 4.1 4.1 2.1 - for each 4 margins of the plot
par("bg")  # "white"
par("las")  # 0
par("oma")  # 0 0 0 0
par("mfcol")  # 1 1 

parameters <- list("pch","lty","lwd","col","mar","bg","las","oma","mfcol","mfrow")
for(i in parameters){
  print(par(i))
}

# key base plotting functions

# plot() makes a scatter plot, or other types of plot depending on the class of data
# lines() adds lines to plot, given 2 vectors of x,y values, this function just connects dots
# points() adds points to a plot
# text() adds labels to plots, using specified x,y coordinates (inside the plot)
# title() adds annotations to x,y labels, title, subtitle, outer margin (outside the plot, in the margin regions)
# mtext() adds arbitrary text to margins
# axis() specifies the axis ticks

albania <- lifeEXP %>% filter(Country == "Albania")
plot(albania$Year, albania$`Life expectancy`, xlab = "", ylab = "", col="red")
# if axes labels aren't specified to "" in the plot() call, label overlap will occur from both functions.
title(main = "Changes in life expectancy of Albanians over years", xlab = "Years", ylab = "Life expectancy (Years)")

# using with()
with(albania, plot(Year, `Life expectancy`, xlab = "Years", ylab = "Life expectancy (Years)", col="red"))

# adding points representing Albania
with(lifeEXP, plot(Year, `Life expectancy`, col = "red", xlab = "Year", ylab = "Life expectancy"))
with(subset(lifeEXP, Country == "Albania"), points(Year,`Life expectancy`, col= "blue", pch = 19))

with(lifeEXP, plot(Year,`Adult Mortality`, main = "Changes in global adunt mortality over years", xlab="Years",ylab="Adult mortality"))
with(subset(lifeEXP, Status =="Developed"), points(Year,`Adult Mortality`, pch = 19, col = "green"))

with(subset(lifeEXP, Status =="Developing"), points(Year,`Adult Mortality`, pch = 1, col = "red"))
with(subset(lifeEXP, Status =="Developed"), points(Year,`Adult Mortality`, pch = 1, col = "blue"))

# specifying type = "n" just initializes the plot palette, without adding any elements to it.
with(lifeEXP, plot(Year, `Adult Mortality`, main="Adult mortality rates", type = "n"))

with(lifeEXP, plot(Year, `Adult Mortality`, main="Adult mortality rates", type = "n"))
with(subset(lifeEXP, Country == "Albania"), points(Year, `Adult Mortality`, pch=19, col="#0085F1"))
with(subset(lifeEXP, Country == "Algeria"), points(Year, `Adult Mortality`, pch=19, col="#FB00F1"))
with(subset(lifeEXP, Country == "Belgium"), points(Year, `Adult Mortality`, pch=19, col="#FB007B"))

with(lifeEXP, plot(Year, `Adult Mortality`, main="Adult mortality rates", type = "n"))
with(subset(lifeEXP, Country == "Albania"), points(Year, `Adult Mortality`, pch=19, col="#0085F1"))
with(subset(lifeEXP, Country == "Algeria"), points(Year, `Adult Mortality`, pch=19, col="#FB00F1"))
with(subset(lifeEXP, Country == "Belgium"), points(Year, `Adult Mortality`, pch=19, col="#FB007B"))
legend(x=2010, y=650, col = c("#0085F1","#FB00F1","#FB007B"), pch=19, legend = c("Albania","Algeria","Belgium"), xjust =.02)

# adding regression lines
rline <- lm(lifeEXP$`Adult Mortality`~ lifeEXP$`Life expectancy`, lifeEXP)
# this returns the coefficients of a linear regression model, intercept & slope!
with(lifeEXP, plot(`Life expectancy`,`Adult Mortality`, pch=19, 
                   col="red", xlab="Life expectancy", ylab="Adult Mortality"))
abline(rline, lwd=3.5, col="blue", lty="dotted")

# multiple plots on a single frame
par(mfrow=c(1,2))
with(lifeEXP, {
  plot(`Life expectancy`,`Adult Mortality`, pch=1, 
            col="red", main="Adult mortality vs Life expectancy", xlab="Life expectancy", ylab="Adult Mortality")
  plot(`Life expectancy`,`infant deaths`, pch=1, 
       col="blue", main="Infant Deaths vs Life expectancy", xlab="Life expectancy", ylab="Infant Mortality")
})
    

par(mfrow=c(1,3), oma=c(1,1,2,1))
with(lifeEXP, {
  plot(`Life expectancy`,`Adult Mortality`, pch=1, 
       col="red", main="Adult mortality vs Life expectancy", xlab="Life expectancy", ylab="Adult Mortality")
  plot(`Life expectancy`,`infant deaths`, pch=1, 
       col="blue", main="Infant Deaths vs Life expectancy", xlab="Life expectancy", ylab="Infant Mortality")
  plot(`Life expectancy`,Alcohol, pch=1, 
       col="violet", main="Alcohol consumption vs Life expectancy", xlab="Life expectancy", ylab="Alcohol consumption")
  mtext("Inferences from the Gapminder dataset", side = 3, outer = TRUE)
})

# margins are enumerated starting from the bottom of the plot and then moving clockwise
# bottom - 1, left - 2, top - 3, right - 4

par(mar=c(4,1,1,1))
plot(rnorm(100),rnorm(100))

par(mar=c(4,4,1,1))
plot(rnorm(100),rnorm(100))

par(mar=c(4,4,4,1))
plot(rnorm(100),rnorm(100))

par(mar=c(4,4,4,4))
plot(rnorm(100),rnorm(100))

for(i in seq(0,20,1)){
  par(mar=c(2,2,2,2))
  plot(rnorm(100), rnorm(100), pch=i, xlab = "X", ylab = "Y", main = "Plotting characters")
  legend("topright",legend = i, pch = i)
  Sys.sleep(1)
}

# mfrow, mfcol in the par() do essentially the same job, but if mfrow is used 
# subplots are arranged row wise in the canvas
# if mfcol is used subplots are arranged column wise in the canvas

par(mfrow=c(2,2), mar=c(4,4,2,2)) # creates a 2x2 canvas
plot(rnorm(50),rnorm(50), pch=19, xlab = "X", ylab = "Y", col="red", main = "Plot 1")
plot(rnorm(50),rnorm(50), pch=19, xlab = "X", ylab = "Y", col="blue", main = "Plot 2")
plot(rnorm(50),rnorm(50), pch=19, xlab = "X", ylab = "Y", col="purple", main = "Plot 3")
plot(rnorm(50),rnorm(50), pch=19, xlab = "X", ylab = "Y", col="green", main = "Plot 4")

par(mfcol=c(2,2), mar=c(4,4,2,2)) # creates a 2x2 canvas
plot(rnorm(50),rnorm(50), pch=19, xlab = "X", ylab = "Y", col="red", main = "Plot 1")
plot(rnorm(50),rnorm(50), pch=19, xlab = "X", ylab = "Y", col="blue", main = "Plot 2")
plot(rnorm(50),rnorm(50), pch=19, xlab = "X", ylab = "Y", col="purple", main = "Plot 3")
plot(rnorm(50),rnorm(50), pch=19, xlab = "X", ylab = "Y", col="green", main = "Plot 4")

