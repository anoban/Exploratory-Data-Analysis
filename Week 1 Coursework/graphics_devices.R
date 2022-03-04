# Graphics devices are some place where plots appear
# eg. a window on the computer i.e screen device
# a PDF file, a PNG/jpeg file, a scalable vector graphics (SVG) i.e file devices
# a plot made in R needs to be sent to a specific graphics device
# on windows platform the screen device is launched by windows() function

# saving to file devices
pdf(file = "plot.pdf") # opens a file device
plot(...............) # create the plot
dev.off() # close the file device
# now the plot.pdf will be available in the working directory

library(tidyverse)
powcon <- read.delim("C:\\Users\\Anoba\\Documents\\GitHub\\EXDATA1\\Week_1\\household_power_consumption.txt", sep = ";", header = TRUE)
pdf(file = "powercons.pdf", width = 12, height = 12, onefile = TRUE)
plot(powcon$Date, powcon$Global_active_power, main = "Power consumption per date", xlab = "Date", ylab = "Active power consumption (kilowatts)")
dev.off()

# there are two main types of file devices
# vector formats: pdf, svg, win.metafile, postscript
# bitmap formats: png, jpeg, tiff, bmf


# pdf is useful for line type graphics, resizes well, portable but not efficient if the plot
# has many elements as file size can get extremely bigger since more information needs to be stored in the file format
# svg is a xml based scalar vector graphics, supports animation & interactivity
# best for web based plots
# win.metafile is a windows metafile format that works only on Windows platforms
# postscript is an older format, resizes well, portable & usually Windows platforms do not have a 
# postscript viewer


# png is good for line drawings, images with solid colours, uses lossless compression, good for plotting mana points
# does not resize well, pixel break may occur if enlarged much
# jpeg is good for photographs and natural scenes, uses lossy compression, good for plotting many points
# does not resize well, not good for line drawings
# tiff format supports lossless compression
# bmp is a windows native bitmap format

# it is possible to open multiple graphics devices simultaneously: screen/file/both
# plotting can only occur in one device at once
# currently active graphics device can be found by the dev.cur() function
# current graphics device can be changed by dev.set() function
# every open graphics device is assigned an  integer (>=2)
# an integer value representing the desired graphics device must be passed to the dev.set() function!


# copying plots from one device to another
# most commonly used to save a plot created on a screen device to a local file
# there are two ways to do this: dev.copy() and dev.copy2pdf()
# dev.copy() copies a file from one device to another
# dev.copy2pdf() copies a plot to a pdf file device

library(lubridate)
data <- powcon %>% mutate(Date = dmy(Date)) %>% mutate(Date = as.factor(Date)) %>%
  filter(Date %in% c("2006-12-20","2006-12-19","2006-12-18","2006-12-17","2006-12-16","2006-12-15"))
par(mfrow=c(1,1), mar=c(1,1,1,1))
plot(as.factor(powcon$Date), as.numeric(powcon$Global_active_power), main = "Daily power consumption", xlab = "Date", ylab = "Active power consumption (kilowatts)")
dev.copy(pdf, file="pcons.pdf")
dev.off()
