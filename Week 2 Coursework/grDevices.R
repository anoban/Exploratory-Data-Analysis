# colors in R

# Of course, color choice is secondary to your data and how you analyze it, but
# effectively using colors can enhance your plots and presentations, emphasizing
# the important points you're trying to convey. 

# the first 3 default colors in R are white, red & green
# color = c(1:3) will give the above colors

# many color packages come with the package grDevices!
# eg: heat.colors, topo.colors
# heat.colors: Here low values are represented in red and as the values
# increase the colors move through yellow towards white.
# topo.colors: uses topographical colors ranging from blue (low values)
# towards brown (higher values)

# function colors() from grDevices lists the names of 657 predefined colors you can use in any
# plotting function.
# there are a lot of variety in the colors, some of which are names followed by
# numbers indicating that there are multiple forms of that particular color

# two additional functions from grDevices, colorRamp and colorRampPalette,give you more options. 
# Both of these take color names as arguments and use them
# as "palettes", that is, these argument colors are blended in different proportions to form new colors.

# colorRamp, takes a palette of colors (the arguments) and returns a
# function that takes values between 0 and 1 as arguments. The 0 and 1 correspond
# to the extremes of the color palette. Arguments between 0 and 1 return blends of these extremes.

# creating a function of 2 palettes with red & blue colors
# assigning the function to a variable named palette
palette <- colorRamp(c("red","blue"))

palette(0) 
# returns 1 by 3 array with 255 as the first entry and 0 in the other 2. 
# This 3 long vector corresponds to red, green, blue (RGB) color encoding commonly used in televisions and monitors. 
# In R, 24 bits are used to represent colors. 
# Think of these 24 bits as 3 sets of 8 bits
# each of which represents an intensity for one of the colors red, green, and blue.

#  The 255 returned from the pal(0) call corresponds to the largest possible number
# represented with 8 bits, so the vector (255,0,0) contains only red (no green or
# blue), and moreover, it's the highest possible value of red.

palette(1) 
# will return a RGB code for blue color!
# the vector (0,0,255) which represents the highest intensity of blue

palette(0.5)
# (127.5,0,127.5) half the maximum values for R & B with 0 for G

# The function palette() can take more than one argument. 
# It returns one 3-long (or 4-long, but more about this later) vector for each argument.
palette(seq(0,1,len=6)) 
# passing in a sequence of 6 numbers within the range of 0 & 1

#       [,1] [,2] [,3]
# [1,]  255    0    0
# [2,]  204    0   51
# [3,]  153    0  102
# [4,]  102    0  153
# [5,]   51    0  204
# [6,]    0    0  255

# Six vectors (each of length 3) are returned. 
# The i-th vector is identical to output that would be returned by the call palette(i/5) for i=0,...5. 
# We see that the i-th row (for i=1,...6) differs from the (i-1)-st row in the following way. 
# Its red entry is 51 (= 255/5) points lower and its blue entry is 51 points higher.

# In this example none of pal's outputs will ever contain green since it wasn't in our initial palette.


# colorRampPalette(), is a function similar to colorRamp. 
# It also takes a palette of colors and returns a function. 
# This function, however, takes integer arguments (instead of numbers between 0 and 1) and returns a vector of
# colors each of which is a blend of colors of the original palette.

# The argument you pass to the returned function specifies the number of colors you want returned. 
# Each element of the returned vector is a 24 bit number, represented as 6 hexadecimal characters, 
# which range from 0 to F. 
# This set of 6 hex characters represents the intensities of red, green, and blue, 2 characters for each color

palette <- colorRampPalette(c("red","blue"))
palette(2) # "#FF0000" "#0000FF"
# a 2-long vector is returned. The first entry FF0000 represents red. The FF is hexadecimal for 255, 
# the same value returned by our call palette(0) with colorRamp(). 
# The second entry 0000FF represents blue, also with intensity 255.

palette(6) # "#FF0000" "#CC0033" "#990066" "#650099" "#3200CC" "#0000FF"
# We see the two ends (FF0000 and 0000FF) are consistent with the colors red and blue.
# How about CC0033?
# type 0xcc or 0xCC at the command line to see the decimal equivalent of this hex number. 
# must include the 0 before the x to specify that you're entering a hexadecimal number.

# So 0xCC equals 204 and we can easily convert hex 33 to decimal, as in 0x33=3*16+3=51. 
# These were exactly the numbers we got in the second row returned from our call to palette(seq(0,1,len=6)). 
# We see that 4 of the 6 numbers agree with our earlier call to pal.
# Two of the 6 differ slightly.

palette <- colorRampPalette(c("red","yellow"))
palette(2) 
# "#FF0000" "#FFFF00"
# first color we see is FF0000, which we know represents red.
# The second color returned, FFFF00, must represent yellow, a combination of full
# intensity red and full intensity green. This makes sense, since yellow falls
# between red and green on the color wheel.

palette(10)
# "#FF0000" "#FF1C00" "#FF3800" "#FF5500" "#FF7100" "#FF8D00" "#FFAA00" "#FFC600" "#FFE200" "#FFFF00"
# in the 10-long vector, for each element, the red component is fixed at FF,
# and the green component grows from 00 (at the first element) to FF (at the last).

# to see the code of palette() function
palette
# is a short function with one argument, n. The argument n is used as the length in a call to 
# the function seq.int, itself an argument to the function ramp. 
# We can infer that ramp is just going to divide the interval from 0 to 1 into n pieces.

rgb(red = 0.5, green = 0.6, blue = 0.23)
# rgb is a color specification function that can be used to produce any color with red, green, blue 
# proportions. We see the maxColorValue is 1 by default, so if we called rgb with values for red, 
# green and blue, we would specify numbers at most 1 (assuming we didn't change the default for maxColorValue)
# fourth argument is alpha which can be a logical, i.e., either TRUE or FALSE, or a numerical value

palette <- colorRampPalette(c("blue","green"), alpha=0.5)
palette(5) # "#0000FFFF" "#003FBFFF" "#007F7FFF" "#00BF3FFF" "#00FF00FF"

# in the 5-long vector that the call returned, each element has 32 bits, 4 groups of 8 bits each. 
# The last 8 bits represent the value of alpha.
# Since it was NOT ZERO in the call to colorRampPalette, it gets the maximum FF value. 
# (The same result would happen if alpha had been set to TRUE.) 
# When it was 0 or FALSE (as in previous calls to colorRampPalette) it was given the value 00 and wasn't shown.
# The leftmost 24 bits of each element are the same RGB encoding we previously saw.

palette <- colorRampPalette(c("blue","green"), alpha= TRUE)
palette(5) 

x <- rnorm(1000)
y <- rnorm(n=1000, sd=.125, m=0.1)
plot(x,y,pch=19,col=rgb(0,0.5,0.5))

# Well this picture is okay for a scatterplot, a nice mix of blue and green, but it
# really doesn't tell us too much information in the center portion, since the points are so cluttered there. 
# We see there are a lot of points, but is one area more filled than another? 
# We can't really discriminate between different point densities. 
# This is where the alpha argument can help us. 

plot(x,y,pch=19,col=rgb(0,0.5,0.5, alpha = 0.3))

# RColorBrewer Package

# contains interesting and useful color palettes, of which there are 3 types,
# sequential, divergent, and qualitative. Which one you would choose to use depends on your data.

# These colorBrewer palettes can be used in conjunction with the colorRamp() and colorRampPalette() functions.
# You would use colors from a colorBrewer palette as your base palette,i.e., 
# as arguments to colorRamp or colorRampPalette which would interpolate them to create new colors.

# the function brewer.pal with 2 arguments, 3 and "BuGn". 
# The string "BuGn" is a palette type. 
# The 3 tells the function how many different colors we want.
cols <- brewer.pal(3, "BuGn")

# Alpha represents an opacity level, that is, how transparent
# should the colors be. We can add color transparency with the alpha parameter to calls to rgb

