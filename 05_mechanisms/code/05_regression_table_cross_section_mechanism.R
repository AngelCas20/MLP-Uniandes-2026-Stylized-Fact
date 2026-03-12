### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/03_geometric_growth_mechanism.rds',
            setclass = 'tibble')

##==: 2. Run regression

model_iid_1 = feols(data = df,capital_per_capita ~ loan_accounts_commercial_banks)
model_iid_2 = feols(data = df,capital_per_capita ~ outstanding_loans_commercial_banks)

model_robust_1 = feols(data = df,capital_per_capita ~ loan_accounts_commercial_banks,se = 'hetero')
model_robust_2 = feols(data = df,capital_per_capita ~ outstanding_loans_commercial_banks,se = 'hetero')

etable(model_iid_1,model_robust_1,model_iid_2,model_robust_2)

##==: 3. Make table

tabla = etable(model_iid_1,model_robust_1,model_iid_2,model_robust_2,
               dict = c('capital_per_capita' = '$\\Delta$ Stock de Capital \nper cápita',
                        'outstanding_loans_commercial_banks' = "$\\Delta$ Cuentas de créditos \n en el sistema financiero",
                        'loan_accounts_commercial_banks' = '$\\Delta$ Cartera acumulada de créditos \n en el sistema financiero'),
              fitstat = ~ n + ar2,
              digits = 3,
              tex = TRUE,
              se.row = TRUE
              ) %>%
        as.character()

tabla[5] = str_replace_all(tabla[5],'Dependent Variables:',' ')
tabla[6] = str_replace_all(tabla[6],'Model:','Modelo:')
tabla[8] = ' '
tabla[9] = str_replace_all(tabla[9],'Constant','Constante')
tabla = tabla[c(-14)]
tabla[17] = str_replace_all(tabla[17],'Standard-Errors','Errores estándar')
tabla[17] = str_replace_all(tabla[17],'Heteroskedasticity-robust','HC1')
tabla[18] = str_replace_all(tabla[18],'Observations','Observaciones')
tabla[19] = str_replace_all(tabla[19],"Adjusted","Adj")
tabla = tabla[c(-21)]

##==: 4. Save table

write_lines(tabla,'05_mechanisms/output/05_regression_table_cross_section_mechanism.tex')
