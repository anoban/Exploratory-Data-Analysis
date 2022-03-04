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

library(tidyverse)  # loading the tidyverse packages

# extracting the rows for Baltimore city
baltimore <- dat_summarypm25 %>% filter(fips == "24510")

# extracting the SCC IDs from dat_scc dataframe with the string "vehicle" 
# in `SCC.Level.Two` column
vehicle_ind <- grepl("vehicle", dat_scc$SCC.Level.Two, ignore.case = TRUE)
scc_id <- unique(dat_scc[vehicle_ind,]$SCC)

# extracting the rows for vehicle based emission sources in Baltimore
VBaltimore <- baltimore %>% filter(SCC %in% scc_id) %>%
  select(year, Emissions) %>%
  mutate(year = as.factor(year))

# plotting
VBaltimore %>% ggplot(aes(x = year, y = Emissions))+
  geom_col(fill="#FF20AC")+
  xlab("Years")+
  ylab("PM2.5 emissions from Motor vehicles")+
  ggtitle("Change in PM2.5 emissions from Motor vehicles in Baltimore city over years")

# saving the plot to a png file
ggsave("plot5.png", device = png, width = 10, height = 10, units = "in")

#############################################################################################################
# Emissions from motor vehicles have gradually decreased in Baltimore city from 1999 to 2008.