#==================#
# Yesenia Fontalvo #
#==================#
rm(list = ls())
source("00_programs/00_packages.R")

# 01. Import 
data = import("01_data/output/01_wb_global_findex_db_2025.rds") %>%  
       subset(year == 2024)  %>%  
       select(year, codewb, pop_adult , incomegroupwb24, group, account_t_d) %>% 
       subset(group == "all") %>%  
       mutate(account_t_d = as.numeric(account_t_d), 
              pop_adult = as.numeric(pop_adult))
      
mean = data %>%  
       group_by(incomegroupwb24) %>% 
       summarise(mean = weighted.mean(account_t_d, pop_adult, na.rm = TRUE))

export(mean, "03_compute/output/02_tasas.xlsx")
