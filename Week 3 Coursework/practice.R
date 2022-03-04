library(tidyverse)

data <- read_csv("D:\\Python\\Life_Expectancy_Data.csv", col_names = TRUE)

char_cols <- data[,c(1,3)] %>% apply(FUN = as.character, MARGIN = 2) %>% as_tibble()
num_cols <- data[,c(2,4:8,11,12,14,17,18,21,22)] %>% 
  apply(FUN = as.numeric, MARGIN = 2) %>%
  as_tibble()

tidyDATA <- cbind(char_cols, num_cols)

tidyDATA %>% filter(Status == "Developed") %>% 
  select(-c("Country","Status","Year")) %>%
  colMeans(na.rm = TRUE)

developed_list <- tidyDATA %>% filter(Status == "Developed") %>% 
  group_split(Country)
developed_countries <- tidyDATA %>% filter(Status == "Developed") %>% .$Country %>% unique()


for (i in 1:32) {globalVariables(`names<-`(developed_list[[i]],developed_countries[i]))}


lapply(developed_list, FUN = names()<-)



%>%
  select(-c("Country","Status","Year"))
  