################################################################
# a conditional code chunk to download and load the .Rds files #
################################################################

if (file.exists("exdata_data_NEI_data.zip") == TRUE) {  # if the zip file is already available in the working directory
  scc <- unzip("exdata_data_NEI_data.zip", list = TRUE)[1,1]  #  capturing the name of first .Rds file in variable scc
  summarypm25 <- unzip("exdata_data_NEI_data.zip", list = TRUE)[2,1]  #  capturing the name of second .Rds file in variable summarypm25
  unzip("exdata_data_NEI_data.zip", exdir = getwd())   # unzip the .zip file and extract the contents to working directory
  dat_summarypm25 <- readRDS(paste0(getwd(),"/",summarypm25)) # load in the second .Rds file as dat_summarypm25
  dat_scc <- readRDS(paste0(getwd(),"/",scc))  # load in the first .Rds file as dat_scc
  } else { if(file.exists("exdata_data_NEI_data.zip") == FALSE) { # if the zip file is not available in the working directory
  download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "exdata_data_NEI_data.zip")  # download the .zip file from course website
  scc <- unzip("exdata_data_NEI_data.zip", list = TRUE)[1,1]
  summarypm25 <- unzip("exdata_data_NEI_data.zip", list = TRUE)[2,1]
  unzip("exdata_data_NEI_data.zip", exdir = getwd())
  dat_summarypm25 <- readRDS(paste0(getwd(),"/", summarypm25))
  dat_scc <- readRDS(paste0(getwd(),"/", scc))
  }
}

library(tidyverse)  # load the tidyverse package

# extracting the rows specific to Baltimore city
baltimore <- dat_summarypm25 %>% filter(fips == "24510") %>%
		select(Emissions, year, type) %>% mutate(year = as.factor(year))

# subsetting the Baltimore dataframe into 4 dataframes based on 4 types of PM 2.5 sources in `type` column
type_split <- baltimore %>% group_split(type)
non_road <- type_split[[1]]
non_point <- type_split[[2]]
on_road <- type_split[[3]]
point <- type_split[[4]]

# creating an empty dataframe with years for row names; to append sums via loops
dframe <- data.frame(non_road = rep(NA,4), non_point = rep(NA,4), on_road = rep(NA,4), point =rep(NA,4))
row.names(dframe) <- c("1999","2002","2005","2008")

# creating the iterables needed for loop computations
y <- c("1999","2002","2005","2008")  # a character vector of years
objs <- list(non_road, non_point, on_road, point)  # a list of all the 4 splitted dataframes
label <- c("non_road", "non_point", "on_road", "point")  # a character vector of 4 types of PM 2.5 sources

# a nested for loop for calculating the emission sums for each year and each source
# and appending the computed sums to the dframe dataframe
for (i in 1:4) {
  for (x in 1:4) {
    dframe[y[x],label[i]] <- sum(objs[[i]][objs[[i]]["year"] == y[x],][,"Emissions"])
  }
}

# removing the years from row names
rownames(dframe) <- NULL
# reintroducing the years as the first column; just to make the plotting easier
dat <- data.frame(Years = c("1999","2002","2005","2008"), dframe)

# creating plots for each of the 4 types of PM 2.5 sources
p1 <- dat %>% ggplot(aes(x = Years, y = non_road))+
  geom_col(fill="#82DDB6", color="black") +
  xlab("Years") +
  ylim(0,2250) +
  ylab("Total yearly emission")+
  ggtitle("Non-road sources")
p2 <- dat %>% ggplot(aes(x = Years, y = non_point))+
  geom_col(fill="#DBDDB6", color="black")+
  xlab("Years") +
  ylim(0,2250) +
  ylab("Total yearly emission")+
  ggtitle("Non-point sources")
p3 <- dat %>% ggplot(aes(x = Years, y = on_road))+
  geom_col(fill="#5440C2", color="black")+
  xlab("Years") +
  ylim(0,2250) +
  ylab("Total yearly emission")+
  ggtitle("On-road sources")
p4 <- dat %>% ggplot(aes(x = Years, y = point))+
  geom_col(fill="#54E750", color="black")+
  xlab("Years") +
  ylim(0,2250) +
  ylab("Total yearly emission")+
  ggtitle("Point sources")

# loading the grid, gridExtra packages
library(grid)
library(gridExtra)

# arranging the 4 plots in an 1x4 grid and saving it as a png file.
ggsave(filename = "plot3.png", plot = arrangeGrob(p1,p2,p3,p4, nrow =1, ncol = 4, 
        top = textGrob("Changes in yearly PM2.5 emissions from different sources", gp = gpar(fontsize=20))), 
       device = png, width = 30, height = 16, units = "in")

############################################################################################################
# The overall trend in emissions is a gradual decrease
# This applies to non-road, on-road & point sources
# However the emissions from point sources show a steady increase with 2009 being an exception with a
# rapid drop in emissions.