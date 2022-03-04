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

# extracting the SCC IDs from dat_scc dataframe with the string "vehicle" 
# in `SCC.Level.Two` column
vehicle_ind <- grepl("vehicle", dat_scc$SCC.Level.Two, ignore.case = TRUE)
scc_id <- unique(dat_scc[vehicle_ind,]$SCC)

# loading the tidyverse packages
library(tidyverse)

# extracting the emission data with PM 2.5 source as vehicles
vehicleDF <- dat_summarypm25 %>% filter(SCC %in% scc_id) %>%
  mutate(year = as.factor(year))

# selecting the rows for emissions from vehicles and from Baltimore & Los Angeles
ballosVehicle <- vehicleDF %>% filter(fips %in% c("24510","06037")) %>%
  select(year, fips, Emissions)

place <- ballosVehicle %>% .$fips %>% 
  recode("24510" = "Baltimore city","06037" = "Los Angeles County") %>%
  as.factor()

ballosVehicle<- cbind(ballosVehicle, place)

# plotting
ballosVehicle %>% ggplot(aes(x = year, y = Emissions)) +
  geom_col(aes(fill = place))+
  xlab("Years")+
  ylab("PM 2.5 emissions from Motor vehicles")+
  ggtitle("PM 2.5 emissions from Motor vehicles in Baltimore & Los Angeles over years")+
  facet_grid(.~ place)+
  theme(legend.position = "None")

# saving the plot to a png file
ggsave("plot6.png", device = png, width = 15, height = 10, units = "in")

############################################################################################################
# PM 2.5 emission from motor vehicles in Baltimore is substantially low compared to the emissions from 
# Los Angeles city.
# Changes in emissions are noticably high in LA compared to Baltimore
# However the percentage change might be higher in Baltimore than LA since the total emissions from 
# Baltimore are significantly lower than that of LA.