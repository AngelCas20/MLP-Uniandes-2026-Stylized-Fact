#------------------------#
# Angel Castillo Negrete #
#    2026 - 03 - 10      #
#------------------------#

### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

imf = import('01_data/output/01_imf_data.rds',
            setclass = 'tibble') 

pwt = import('01_data/output/01_pwt110.rds',
            setclass = 'tibble')            

a = import('02_wrangle/output/01_geometric_growth.rds',
           setclass = 'tibble')

##==: 2. Wrangle dataset

### 2.1 IMF data
imf = imf %>% 
      filter(str_detect(string = indicator,pattern = 'Borrowers, Commercial banks|Outstanding loans, Commercial banks')==T) %>% 
      filter(str_detect(string = indicator,pattern = 'SME')) %>% 
      filter(str_detect(string = indicator,pattern = 'Assets',negate = TRUE)) %>% 
      filter(type_of_transformation != 'Number') %>% 
      select(country,indicator,type_of_transformation,year = time_period,value = obs_value) 

### 2.2 Remove add isocode and remove na values
imf = imf %>% 
      mutate(isocode = countrycode(country,origin = 'country.name',destination = 'iso3c')) %>% 
      drop_na(year,value,isocode) 

### 2.3 Rearrange dataset
imf = imf %>% 
      select(isocode,year,value,indicator) %>% 
      mutate(indicator = to_snake_case(indicator)) %>% 
      pivot_wider(names_from = indicator,values_from = value) 

imf = imf %>% 
      rename(sme_borrowers_account= borrowers_commercial_banks_small_and_medium_enterprises_sm_es,
             sme_loan_value_gdp_with_commercial_banks = outstanding_loans_commercial_banks_small_and_medium_enterprises_sm_es)

### 2.4 Clean Penn World Table
pwt = pwt %>% 
      mutate(gdp_per_capita = rgdpo/pop,
             capital_per_capita = rnna/pop) %>% 
      select(year,isocode = countrycode,country,gdp_per_capita,capital_per_capita) %>% 
      arrange(isocode,year) %>% 
      drop_na(capital_per_capita)

##==: 3. Prepare data for for analysis 

### 3.1 Merge dataset
data = inner_join(x = pwt,y = imf,by = c('year','isocode'))

### 3.2 Exclude Venezuela
data = data %>% 
       filter(isocode != 'VEN')

##==: 4. Compute geometric growth rate dataset

### 4.1 Set time period
interest_period = c(2020,2023)

### 4.2 Compute time difference
time_diff = diff(interest_period)

### 4.3 Filter for interest period and balance panel
geometric_growth = data %>% 
                   filter(year %in% interest_period) %>% 
                   drop_na(sme_loan_account) %>% 
                   group_by(isocode) %>% 
                   filter(n() == 2) %>% 
                   ungroup() 


### 4.4 Compute geometric growth 
geometric_growth = geometric_growth %>% 
                   group_by(isocode) %>% 
                   summarise(across(.cols = c(sme_loan_account,gdp_per_capita,capital_per_capita),
                                    .fns = function(x){
                                     x = (x/lag(x))^(1/time_diff) -1
                                     x = max(x,na.rm = T)
                            })) %>% 
                   ungroup()

h = inner_join(x = geometric_growth,y = a %>% select(isocode,number_accounts_1000_adults))

feols(h,sme_loan_account  ~ number_accounts_1000_adults) %>% 
  etable()
