#------------------------#
# Angel Castillo Negrete #
#    2026 - 03 - 07      #
#------------------------#

### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

wb = import('01_data/output/01_wb_global_findex_db_2025.rds',
            setclass = 'tibble')
     
pwt = import('01_data/output/01_pwt110.rds',
            setclass = 'tibble')            

##==: 2. Wrangle data

### 2.1 Clean World Bank data
wb = wb %>% 
     slice(-1) %>% 
     filter(group == 'all') %>% 
     select(year,isocode = codewb,incomegroupwb24,share_adults_financial_account =  account_t_d) %>% 
     mutate(share_adults_financial_account = as.numeric(share_adults_financial_account),
            year = as.numeric(year)) %>% 
     arrange(isocode,year) 

### 2.2 Clean Penn World Table
pwt = pwt %>% 
      mutate(gdp_per_capita = rgdpo/pop,
             capital_per_capita = rnna/pop) %>% 
      select(year,isocode = countrycode,country,gdp_per_capita,capital_per_capita) %>% 
      arrange(isocode,year) %>% 
      drop_na(capital_per_capita)

##==: 3. Filter for analysis period and balance panel

interest_period = c(2011,2021)

wb = wb %>% 
     filter(year %in% interest_period) %>% 
     group_by(isocode) %>% 
     filter(n() == 2) %>% 
     ungroup()

pwt = pwt %>% 
      filter(year %in% interest_period) %>% 
      group_by(isocode) %>% 
      filter(n() == 2) %>% 
      ungroup()

##==: 4. Merge dataset

data = inner_join(x = wb,y = pwt,by = c('year','isocode')) %>% 
       relocate(year,isocode,country,income_group = incomegroupwb24)

### 4.1 Remove venezuela from dataset
data = data %>% 
       filter(isocode != 'VEN')

##==: 5. Compute growth rate

time_diff = diff(interest_period)

geometric_growth = data %>% 
                   group_by(isocode,income_group) %>% 
                   summarise(across(.cols = c(share_adults_financial_account,gdp_per_capita,capital_per_capita),
                                    .fns = function(x){
                                     x = (x/lag(x))^(1/time_diff) -1
                                     x = max(x,na.rm = T)
                              })) %>% 
                   ungroup()

##==: 6. Export data

export(geometric_growth,'02_wrangle/output/01_geometric_growth.rds')
export(data,'02_wrangle/output/01_processed_data.rds')
