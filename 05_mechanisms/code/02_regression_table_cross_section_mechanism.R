### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/03_geometric_growth_mechanism.rds',
            setclass = 'tibble')

##==: 2. Run regression

model_iid = feols(data = df,c(outstanding_loans_commercial_banks,loan_accounts_commercial_banks) ~ number_of_deposit_accounts_commercial_banks)

model_robust = feols(data = df,c(outstanding_loans_commercial_banks,loan_accounts_commercial_banks) ~ number_of_deposit_accounts_commercial_banks,se = 'hc1')

etable(model_iid,model_robust)

##==: 3. Make table

tabla = etable(model_iid,
               model_robust,
               dict = c('number_of_deposit_accounts_commercial_banks' = '$\\Delta$ Cuentas de depósitos \\\\ en el sistema financiero',
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
tabla[14] = str_replace_all(tabla[14],'Standard-Errors','Errores estándar')
tabla[14] = str_replace_all(tabla[14],'Heteroskedasticity-robust','HC1')
tabla[15] = str_replace_all(tabla[15],'Observations','Observaciones')
tabla[16] = str_replace_all(tabla[16],"Adjusted","Adj")

tabla = tabla[c(-18)]

##==: 4. Save
write_lines(tabla,'05_mechanisms/output/02_regression_table_cross_section_mechanism.tex')
