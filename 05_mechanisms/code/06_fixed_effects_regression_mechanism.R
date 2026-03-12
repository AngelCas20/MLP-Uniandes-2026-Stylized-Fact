### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/03_processed_data_mechanism.rds',
            setclass = 'tibble')

##==: 2. Convert variables to log

df = df %>% 
     mutate(across(.cols = c(capital_per_capita,loan_accounts_commercial_banks,outstanding_loans_commercial_banks),
                   .fns = log))

unique_countries = df$isocode %>% unique() %>% length()

##==: 3. Run regression

model1 = feols(data = df,capital_per_capita ~ loan_accounts_commercial_banks|isocode + year)
model2 = feols(data = df,capital_per_capita ~ outstanding_loans_commercial_banks|isocode + year)

etable(model1,model2)

##==: 4. Make table

tabla = etable(model1,model2,
               dict = c('capital_per_capita' = 'ln(Stock de Capital \nper cápita)',
                        'outstanding_loans_commercial_banks' = "ln(Cuentas de créditos \n en el sistema financiero)",
                        'loan_accounts_commercial_banks' = 'ln(Cartera acumulada de créditos \n en el sistema financiero)',
                        'isocode' = 'País',
                        'year' =  'Año'),
              fitstat = ~ n + awr2,
              digits = 3,
              tex = TRUE,
              se.row = TRUE
              ) %>% 
        as.character()

tabla[5] = str_replace_all(tabla[5],'Dependent Variable:',' ')
tabla[6] = str_replace_all(tabla[6],'Model:','Modelo:')
tabla[8] = ' '
tabla[14] = str_replace_all(tabla[14],'Fixed-effects','Efectos fijos')
tabla[15] = str_replace_all(tabla[15],'Yes','\\\\checkmark')
tabla[16] = str_replace_all(tabla[16],'Yes','\\\\checkmark')
tabla = tabla[c(-18,-19)]
tabla[18] = str_replace_all(tabla[18],'Observations','Observaciones')
tabla[19] = str_replace_all(tabla[19],"Adjusted","Adj")
tabla = tabla[c(-21,-22)]

tabla = append(tabla,paste0('Países & ',unique_countries,' & ',unique_countries,'&'),after = 18)

##==: 4. Save table

write_lines(tabla,'05_mechanisms/output/06_regression_table_fixed_effects_mechanism.tex')
