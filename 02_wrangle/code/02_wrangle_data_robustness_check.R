### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

imf = import('01_data/output/01_imf_data.rds',
            setclass = 'tibble') 

pwt = import('01_data/output/01_pwt110.rds',
            setclass = 'tibble')            

##==: 2. Wrangle data

### 2.1 Clean Imf data
imf = imf %>% 
      select(country,indicator,type_of_transformation,year = time_period,value = obs_value) %>% 
      filter(str_detect(indicator,'Number of deposit accounts, Commercial banks')) %>% 
      filter(str_detect(indicator,'Households')==F) 

### 2.2 Remove add isocode and remove na values
imf = imf %>% 
      mutate(isocode = countrycode(country,origin = 'country.name',destination = 'iso3c')) %>% 
      drop_na(year,value,isocode) 

### 2.3 Rearrange dataset
imf = imf %>% 
      select(year,isocode,number_accounts_1000_adults = value)

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
interest_period = c(2004,2019)

### 4.2 Compute time difference
time_diff = diff(interest_period)

### 4.3 Filter for interest period and balance panel
geometric_growth = data %>% 
                   filter(year %in% interest_period) %>% 
                   group_by(isocode) %>% 
                   filter(n() == 2) %>% 
                   ungroup()

### 4.4 Compute geometric growth 
geometric_growth = geometric_growth %>% 
                   group_by(isocode) %>% 
                   summarise(across(.cols = c(number_accounts_1000_adults,gdp_per_capita,capital_per_capita),
                                    .fns = function(x){
                                     x = (x/lag(x))^(1/time_diff) -1
                                     x = max(x,na.rm = T)
                            })) %>% 
                   ungroup()

##==: 5. Export data

export(geometric_growth,'02_wrangle/output/02_geometric_growth_robustness.rds')
