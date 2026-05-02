### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/04_geometric_growth_mechanism_long_run.rds',
            setclass = 'tibble')

##==: 2. Run regressions

### 2.1 Banking on mechanism

model_first_step = feols(data = df,outstanding_loans_commercial_banks ~ number_of_deposit_accounts_commercial_banks,se = 'hetero')

### 2.2 Mechanism on Capital Stock

model_second_step = feols(data = df,capital_per_capita ~ outstanding_loans_commercial_banks,se = 'hetero')

##==: 3. Export

export(model_first_step,'04_mechanisms/output/02_mechanism_cross_section_banking_on_mechanism_long_run.rds')
export(model_second_step,'04_mechanisms/output/02_mechanism_cross_section_capital_on_mechanism_long_run.rds')