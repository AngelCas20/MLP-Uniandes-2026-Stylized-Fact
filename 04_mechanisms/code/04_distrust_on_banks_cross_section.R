### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/05_datos_crisis.rds',
            setclass = "tibble")

##==: 2. Wrangle data

df = df |> 
     mutate(across(.cols = c(mean_loss_gdp_per,sum_loss_gdp_per),.fns = asinh))

##==: 2. Run regressions

model_mean_loss = feols(data = df, number_accounts_1000_adults ~ mean_loss_gdp_per, se = "hetero")

model_sum_loss = feols(data = df, number_accounts_1000_adults ~ sum_loss_gdp_per, se = "hetero")

##==: 3. Export

export(model_mean_loss,'04_mechanisms/output/04_distrust_on_banks_cross_section_mean_loss.rds')
export(model_sum_loss,'04_mechanisms/output/04_distrust_on_banks_cross_section_sum_loss.rds')