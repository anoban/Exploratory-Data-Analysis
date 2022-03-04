# graphs made to see patters for yourself
  # to understand data properties
  # to find patterns in data
  # to suggest modelling strategies
  # to correct analyses
  # to communicate results


# the goal is personal understanding not presentation to an audience
# to discern crude information & patterns from data

library(tidyverse)
library(dplyr)
library(ggplot2)

url <- "https://raw.githubusercontent.com/jtleek/modules/master/04_ExploratoryAnalysis/exploratoryGraphs/data/avgpm25.csv"
pollution <- read_csv(url, col_types = c("n","c","f","n","n")) 
# col_types = data types of the columns

non_compliant <- pollution %>% filter(pm25 > 12)
length(non_compliant$pm25) # 81
mean(non_compliant$pm25) # 13.10866

summary(pollution$pm25)
summary(non_compliant$pm25)

pollution %>% ggplot(aes(y=pollution$pm25))+
  geom_boxplot(fill="red")+
  ylab("Air pollution levels")+
  ggtitle("Boxplot for air pollution over United States")

pollution %>% ggplot(aes(x=pollution$pm25))+
  geom_histogram(binwidth = 0.25, fill="green", color="black")+
  xlab("Pollution")+
  ylab("Count")

pollution %>% ggplot(aes(x=region))+
  geom_bar(fill="blue")+
  xlab("Region")+
  ylab("Count")

pollution %>% ggplot(aes(x=region,y=pm25))+
  geom_boxplot(fill="yellow")
  
pollution %>% ggplot(aes(x=pollution$pm25))+
  geom_histogram(binwidth = 0.5, fill="green", color="black")+
  facet_grid(~region)+
  xlab("Pollution")+
  ylab("Count")

pollution %>% ggplot(aes(x=latitude, y=pm25, color=region))+
  geom_point(alpha=.5, size=2.5)
