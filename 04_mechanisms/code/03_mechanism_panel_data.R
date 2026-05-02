### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/02_processed_data_mechanism.rds',
            setclass = 'tibble')

##==: 2. Convert variables to log

df = df %>% 
     mutate(across(.cols = c(capital_per_capita,number_of_deposit_accounts_commercial_banks),
                   .fns = log))

##==: 3. Run regression

### 3.1 Banking on mechanism
model_first_step = feols(data = df,outstanding_loans_commercial_banks ~ number_of_deposit_accounts_commercial_banks|isocode + year,cluster = 'isocode')

### 3.2 Mechanism on Outcome
model_second_step = feols(data = df,capital_per_capita ~ outstanding_loans_commercial_banks|isocode + year,cluster = 'isocode')

##==: 4. Export 

export(model_first_step,'04_mechanisms/output/03_mechanism_panel_data_banking_on_mechanism.rds')
export(model_second_step,'04_mechanisms/output/03_mechanism_panel_data_capital_on_mechanism.rds')
