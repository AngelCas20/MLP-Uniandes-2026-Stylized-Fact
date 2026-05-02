### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/03_geometric_growth_long_run.rds',
            setclass = 'tibble')

##==: 2. Run regression

model = feols(data = df,c(gdp_per_capita,capital_per_capita) ~ number_accounts_1000_adults,se = 'hetero')

##==: 3. Export

export(model,'03_main_regression/output/02_main_regression_cross_section_long_run')
