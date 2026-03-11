### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/03_processed_data_mechanism.rds',
            setclass = 'tibble')

##==: 2. Convert variables to log
df = df %>% 
     mutate(across(.cols = c(loan_accounts_commercial_banks,number_of_deposit_accounts_commercial_banks),
                   .fns = log))

##==: 3. Run regression
model = feols(data = df,c(outstanding_loans_commercial_banks,loan_accounts_commercial_banks) ~ number_of_deposit_accounts_commercial_banks|isocode + year)
etable(model)

##==: 4. Make table

tabla = etable(model,
               dict = c('number_accounts_1000_adults' = 'ln(Cuentas de depósitos \\\\ en el sistema financiero)',
                        'gdp_per_capita' = "ln(PIB per cápita)",
                        'capital_per_capita' = 'ln(Stock de Capital \nper cápita)',
                        'isocode' = 'País',
                        'year' =  'Año'),
              fitstat = ~ n + awr2,
              digits = 3,
              tex = TRUE,
              se.row = TRUE
              ) %>% 
        as.character()

tabla[5] = str_replace_all(tabla[5],'Dependent Variables:',' ')
tabla[6] = str_replace_all(tabla[6],'Model:','Modelo:')
tabla[8] = ' '
tabla[12] = str_replace_all(tabla[12],'Fixed-effects','Efectos fijos')
tabla[13] = str_replace_all(tabla[13],'Yes','\\\\checkmark')
tabla[14] = str_replace_all(tabla[14],'Yes','\\\\checkmark')
tabla = tabla[c(-16,-17)]
tabla[16] = str_replace_all(tabla[16],'Observations','Observaciones')
tabla[17] = str_replace_all(tabla[17],"Adjusted","Adj")
tabla = tabla[c(-19,-20)]

##==: 4. Save
write_lines(tabla,'05_mechanisms/output/04_regression_table_fixed_effects_mechanism.tex')
