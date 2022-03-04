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

sum(grepl(pattern = "combustion", x= dat_scc$SCC.Level.One, ignore.case=TRUE)) 
# there are 569 rows with the string "combustion" in column `SCC.Level.One`

# selecting only the rows with the string "combustion" in the `SCC.Level.One` column
row_ind <- grepl(pattern = "combustion", x= dat_scc$SCC.Level.One, ignore.case=TRUE)
combustion_df <- dat_scc[row_ind,]


sum(grepl(pattern = "coal", x= dat_scc$SCC.Level.Three, ignore.case=TRUE))
# there are 181 rows with the string "coal" in the `SCC.Level.Three` column

# further selecting only the rows with the string "coal" in the `SCC.Level.Three` column
coal_ind <- grepl(pattern = "coal", x= combustion_df$SCC.Level.Three, ignore.case=TRUE)
coalCombustion_df <- combustion_df[coal_ind,]

# extracting the SCC IDs for coal combustion
scc_id <- unique(coalCombustion_df$SCC)

library(tidyverse) # loading the tisyverse packages

# extracting the emission data using SCC ids for coal combustion sources
coalCombustion_pm2.5 <- dat_summarypm25 %>% filter(SCC %in% scc_id) %>% 
  select(year, Emissions)

# plotting the column plot
coalCombustion_pm2.5 %>% ggplot(aes(x = as.factor(year), y = Emissions)) +
  geom_col(fill = "#DC5C50")+
  ggtitle("Changes in PM2.5 emissions from coal combustion sources in USA over years")+
  xlab("Years", )+
  ylab("PM2.5 emissions")+
  theme(legend.position="None")

# saving the plot to file
ggsave("plot4.png", device = png, width = 10, height = 10, units = "in")

#############################################################################################################
# In USA, the overall PM 2.5 emissions from coal combustion appears to have decreased gradually.
# With the exception of 2005 which shows a slight increase from 2002 emissions.