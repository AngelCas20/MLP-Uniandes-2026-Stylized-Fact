### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

imf = import('01_data/output/01_imf_data.rds',
            setclass = 'tibble') 

pwt = import('01_data/output/01_pwt110.rds',
            setclass = 'tibble')            

##==: 2. Wrangle dataset

### 2.1 Filter for covariates
df = imf %>%
     filter((indicator == 'Outstanding loans, Commercial banks' & type_of_transformation == 'Percent of GDP')|
             indicator == 'Number of deposit accounts, Commercial banks') 

### 2.2 Remove add isocode 
df = df %>% 
     mutate(isocode = countrycode(country,origin = 'country.name',destination = 'iso3c')) %>% 
     drop_na(isocode)

### 2.3 Rearrange dataset
df = df %>% 
     select(isocode,year = time_period,indicator,value = obs_value) %>% 
     mutate(indicator = to_snake_case(indicator))

### 2.4 Pivot table
df = df %>% 
     pivot_wider(id_cols = c(year,isocode),names_from = indicator,values_from = value) %>% 
     drop_na()

### 2.5 Process Penn World Table
pwt = pwt %>% 
      select(isocode  = countrycode,
             year,pop,rnna) %>% 
      mutate(capital_per_capita = rnna/pop) %>% 
      drop_na()

##==: 3. Prepare data for for analysis 

### 3.1 Merge pwt with imf 
data = inner_join(x = pwt,y = df) %>% 
       filter(isocode != 'VEN') %>% 
       arrange(isocode,year)

##==: 4. Test for long lasting effects

### 4.1 First decade 
first_decade = c(2004,2009)

d1 = data |> 
     filter(year %in% first_decade) |> 
     group_by(isocode) |> 
     filter(n() == 2) |> 
     ungroup() |> 
     select(year,isocode,number_of_deposit_accounts_commercial_banks)

### 4.2 second decade 
second_decade = c(2010,2023)

d2 = data |> 
     filter(year %in% second_decade) |> 
     group_by(isocode) |> 
     filter(n() == 2) |> 
     ungroup() |> 
     select(year,isocode,outstanding_loans_commercial_banks)

##==: 5. Compute geometric growth rates

d1 = d1 %>%
     group_by(isocode) |> 
     summarise(across(.cols = c(number_of_deposit_accounts_commercial_banks),
                        .fns = function(x){
                        x = (x/lag(x))^(1/first_decade) -1
                        x = max(x,na.rm = T)}))

d2 = d2 %>%
     group_by(isocode) |> 
     summarise(across(.cols = c(outstanding_loans_commercial_banks),
                        .fns = function(x){
                        x = (x/lag(x))^(1/second_decade) -1
                        x = max(x,na.rm = T)}))

geometric_growth = inner_join(x = d1,y = d2)

##==: 5. Export data

export(geometric_growth,'02_wrangle/output/04_geometric_growth_mechanism_long_run.rds')
