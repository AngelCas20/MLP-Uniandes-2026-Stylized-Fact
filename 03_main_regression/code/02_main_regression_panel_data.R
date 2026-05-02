### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/01_processed_data.rds',
            setclass = 'tibble')

##==: 2. Convert variables to log

df = df %>% 
     mutate(across(.cols = c(gdp_per_capita,capital_per_capita,number_accounts_1000_adults),
                   .fns = log))

##==: 3. Run regression

model = feols(data = df,c(gdp_per_capita,capital_per_capita) ~ number_accounts_1000_adults|isocode + year,cluster = 'isocode')

##==: 4. Export 

export(model,'03_main_regression/output/02_main_regression_panel_data.rds')
