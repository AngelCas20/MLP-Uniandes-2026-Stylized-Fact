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
      mutate(gdp_per_capita = rgdpna/pop,
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
 
##==: 4. Test for long lasting effects

### 4.1 First decade 
first_decade = c(2004,2009)

d1 = data |> 
     filter(year %in% first_decade) |> 
     group_by(isocode) |> 
     filter(n() == 2) |> 
     ungroup() |> 
     select(year,isocode,number_accounts_1000_adults)

### 4.2 second decade 
second_decade = c(2010,2023)

d2 = data |> 
     filter(year %in% second_decade) |> 
     group_by(isocode) |> 
     filter(n() == 2) |> 
     ungroup() |> 
     select(year,isocode,gdp_per_capita,capital_per_capita)

##==: 5. Compute geometric growth rates

d1 = d1 %>%
     group_by(isocode) |> 
     summarise(across(.cols = c(number_accounts_1000_adults),
                        .fns = function(x){
                        x = (x/lag(x))^(1/first_decade) -1
                        x = max(x,na.rm = T)}))

d2 = d2 %>%
     group_by(isocode) |> 
     summarise(across(.cols = c(gdp_per_capita,capital_per_capita),
                        .fns = function(x){
                        x = (x/lag(x))^(1/second_decade) -1
                        x = max(x,na.rm = T)}))

geometric_growth = inner_join(x = d1,y = d2)


##==: 5. Export data

export(geometric_growth,'02_wrangle/output/04_geometric_growth_long_run.rds')
