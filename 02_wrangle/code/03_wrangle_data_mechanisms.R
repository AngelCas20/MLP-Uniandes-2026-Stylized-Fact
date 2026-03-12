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
     filter((indicator == 'Loan accounts, Commercial banks' & type_of_transformation == 'Number')|
             (indicator == 'Outstanding loans, Commercial banks' & type_of_transformation == 'Percent of GDP')|
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
      mutate(capital_per_capita = rnna/pop,
             pop = pop*1e6) %>% 
      drop_na()

##==: 3. Prepare data for for analysis 

### 3.1 Merge pwt with imf 
data = inner_join(x = pwt,y = df) %>% 
       filter(isocode != 'VEN') %>% 
       arrange(isocode,year)

### 3.2 Create normalized rate by a 1000 people
data = data %>% 
       mutate(loan_accounts_commercial_banks = (loan_accounts_commercial_banks/pop)*1000)

##==: 4. Compute geometric growth rate dataset

### 4.1 Set time period
interest_period = c(2004,2023)

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
                   summarise(across(.cols = c(capital_per_capita,outstanding_loans_commercial_banks,loan_accounts_commercial_banks,number_of_deposit_accounts_commercial_banks),
                                    .fns = function(x){
                                     x = (x/lag(x))^(1/time_diff) -1
                                     x = max(x,na.rm = T)
                            })) %>% 
                   ungroup()

##==: 5. Export data

export(geometric_growth,'02_wrangle/output/03_geometric_growth_mechanism.rds')
export(data,'02_wrangle/output/03_processed_data_mechanism.rds')
