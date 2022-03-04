################################################################
# a conditional code chunk to download and load the .Rds files #
################################################################

if (file.exists("exdata_data_NEI_data.zip") == TRUE) {   # if the zip file is already available in the working directory
  scc <- unzip("exdata_data_NEI_data.zip", list = TRUE)[1,1]  #  capturing the name of first .Rds file in variable scc
  summarypm25 <- unzip("exdata_data_NEI_data.zip", list = TRUE)[2,1]  #  capturing the name of second .Rds file in variable summarypm25
  unzip("exdata_data_NEI_data.zip", exdir = getwd())  # unzip the .zip file and extract the contents to working directory
  dat_summarypm25 <- readRDS(paste0(getwd(),"/",summarypm25))  # load in the second .Rds file as dat_summarypm25
  dat_scc <- readRDS(paste0(getwd(),"/",scc))   # load in the first .Rds file as dat_scc
  } else { if(file.exists("exdata_data_NEI_data.zip") == FALSE) {  # if the zip file is not available in the working directory
  download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "exdata_data_NEI_data.zip")  # download the .zip file from course website
  scc <- unzip("exdata_data_NEI_data.zip", list = TRUE)[1,1]
  summarypm25 <- unzip("exdata_data_NEI_data.zip", list = TRUE)[2,1]
  unzip("exdata_data_NEI_data.zip", exdir = getwd())
  dat_summarypm25 <- readRDS(paste0(getwd(),"/", summarypm25))
  dat_scc <- readRDS(paste0(getwd(),"/", scc))
  }
}

dframe <- data.frame(Years = c("1999","2002","2005","2008"), Total_emission = NA, stringsAsFactors = TRUE)
# create a data frame with years for one column and NAs for emissions column
# These NAs will be replaced by the sum of yearly emissions via a for loop (only for the available years)

# for loop for calculating the total yearly emissions of USA and appending the sums to `Total_emission` column of dframe
for (x in c("1999","2002","2005","2008")) {
  dframe[dframe$Years == x,]$Total_emission <- sum(dat_summarypm25[dat_summarypm25$year == x,]$Emissions)
}

png(filename = "plot1.png", width = 1000, height = 1000) # initializing a png file device for plotting
barplot(height = dframe$Total_emission,col = "#EDDDFF", xlab = "Years", 
        ylab = "Total yearly emissions", main = "Changes in Total yearly PM2.5 emissions over years",
        names.arg = dframe$Years, cex.main=2, cex.names = 1.5, cex.lab = 1.5, cex.axis = 1.5)  # creating a barplot using the base plotting system
dev.off() # turning off the png file device


################################################################################################
# The total PM 2.5 emissions appear to have gradually decreased in the United States from 1999 to 2008