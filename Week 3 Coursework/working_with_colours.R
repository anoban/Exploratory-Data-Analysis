# default colour schemes for most plotting systems in R are horrendous
# col argument specifies the color in base and lattice systems
# col = 1 is black, col = 2 is red, col = 3 is green ... etc
# col = c(1,2,3) will give the above series of colours
# a better choice of colours can better demonstrate the idea one is trying to convey
# and can make the plot more informative

# heat.colors(n) function generates n number of colours with red for lower values and
#  yellow and white for higher values
# topo.colours(n) returns a n number of colours with blue for lower values and green, white for 
# higher valuer
# these are called topographical colours

# grDevices package has two functions that take palettes of colours and 
# help to interpolate between colours
    # colorRamp()
    # colorRampPalette()
# these two take primary colours (R, G & B) and mix them in specified proportions to generate new colours
# the function colors() lists all the possible colours that can be used in any plotting function

# colorRamp() takes a palette of colours and returns a function that takes values between 0 & 1
# indicating the two extremes of the colour function
# the default gray() function does the same work but limited to interpolation between black & white

# colorRampPalette() takes a palette of colours and returns a function
# this function takes integer arguments and returns a vector of colours, interpolating the palette
# functions similar to heat.colors() and topo.colors()

# the one rowed matrix with three columns represent the intensities of R,G & B values
cpalette <- colorRamp(c("red","green"))
cpalette(0) # 255    0    0 - specifies red
cpalette(1) # 0  255    0 - specifies green
cpalette(0.5) # 127.5 127.5    0 - mixes red & green in equal proportions

cpalette <- colorRamp(c("blue","green"))
cpalette(0) # 0    0  255 - represents blue
cpalette(1) # 0  255    0 - represents green
cpalette(0.5) # 0 127.5 127.5 - mixes blue and green in equal proportions

cpalette(seq(0,1,length.out = 100))
# this will give 100 different colours produced by mixing blue & green in different proportions

vals <- sqrt(rnorm(100, mean = 0.5, sd = 0.25)^2)  # only positive values between 0 and 1
plot(vals, pch=19)

cpalette <- colorRampPalette(c("red","magenta"))
# colorRampPalette() returns the hex code for colours
# here the RGB values are represented in hexadecimals
# there are six digits (characters): first 2 - represent red, second 2 - green and the last 2 - blue
cpalette(4)
# "#FF0000" "#FF0055" "#FF00AA" "#FF00FF"
cpalette(6)
# "#FF0000" "#FF0033" "#FF0066" "#FF0099" "#FF00CC" "#FF00FF"
# F is the largest value in hexadecimal; F = 16
# so FF0000 is red: R=FF, G=00, B=00
# FF00FF is an equivalent mixture of red and blue; R=FF, G=00, B=FF


# RColorBrewer package
# has three types of palettes:
      # sequential
      # diverging
      # qualitative

# this package can be used in conjunction with colorRamp() and colorRampPalette()
# sequential palette is useful for ordered, numerical/continuous data
# diverging palette is useful for data that deviate from a centre (mean/median)
# positive and negative deviations from a specified centre can be represented by different 
# colourations
# qualitative palette is appropriate for unordered data, data that is categorical/factors

library(RColorBrewer)
col <- brewer.pal(3, "BuGn") 
# first argument is the number of colors to be returned
# second one is the name of the palette
# col - "#E5F5F9" "#99D8C9" "#2CA25F"

# we can further manipulate these colours by using grDevices functions
cpalette <- colorRampPalette(col)
image(volcano, col = cpalette(20))
image(volcano, col = cpalette(40))

# using the default heat.colors() & topo.colors() functions
image(volcano, col = heat.colors(20))
image(volcano, col = topo.colors(20))

# Smooth scatter function
x <- rnorm(1000)
y <- rnorm(1000)
smoothScatter(x,y)
# this is particularly useful when making a scatter plot with lot of points
# this function avoid sthe overlap of points on screen
# smoothScatter() essentially creates a 2D histogram, and then plots the histogram
# using a certain set of colours
# by default this uses a divergent palette
# as the values get higher the colour gets darker and as the values get lower the colour
# gets lighter

smoothScatter(rnorm(10000),rnorm(10000))

# rgb() function can be used to produce any colours via red, green & blue combinations
# values for each r,g & b argument must be an integer in the 0:255 range
# rgb() returns a hexadecimal string
# colour transparency can be introduced via the alpha keyword argument
# alpha = 0; fully transparent
# alpha = 1; no transparency

rgb(0,1,0) # "#00FF00"
rgb(red = 123, green = 231, blue = 79, maxColorValue = 255) # "#7BE74F"


# colorspace package can be used to have more control over colors

plot(x,y, pch=19) # 1000 points plotted on the canvas
# in the centre points are in high density; overlap makes the points inconspicuous
plot(x,y,pch=19,col = rgb(red = 0,green = 0, blue = 1, alpha = 0.2))
# transparency helps to identify regions where the data points overlap intensively
