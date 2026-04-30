### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/05_geometric_growth_mechanism_long_run.rds',
            setclass = 'tibble')

##==: 2. Run regression

### 2.1 Main variable on mechanisms

model_iid_mechanism = feols(data = df,outstanding_loans_commercial_banks ~ number_of_deposit_accounts_commercial_banks)

model_robust_mechanism = feols(data = df,outstanding_loans_commercial_banks ~ number_of_deposit_accounts_commercial_banks,se = 'hc1')

### 2.2 Mechanisms on Capital Stock

model_iid_capital = feols(data = df,capital_per_capita ~ outstanding_loans_commercial_banks)

model_robust_capital = feols(data = df,capital_per_capita ~ outstanding_loans_commercial_banks,se = 'hetero')

##==: 3. Make table

### 3.1 Panel A
tabla_panel_a = etable(model_iid_mechanism,
                       model_robust_mechanism,
                       dict = c('number_of_deposit_accounts_commercial_banks' = '$\\Delta$ Cuentas de depósitos \\\\ en el sistema financiero',
                                'outstanding_loans_commercial_banks' = "$\\Delta$ Valor de créditos vigentes \n en el sistema financiero como \\% del PIB"),
                        fitstat = ~ n + ar2,
                        digits = 3,
                        digits.stats = 3,
                        tex = TRUE,
                        se.row = TRUE
                        ) %>%
            as.character()

##==: 4. Prepare table

### 4.1 Prepare Panel A
tabla_panel_a[5] = str_replace_all(tabla_panel_a[5],'Dependent Variable:',' ')
tabla_panel_a[6] = str_replace_all(tabla_panel_a[6],'Model:','Modelo:')
tabla_panel_a[8] = ' '
tabla_panel_a[9] = str_replace_all(tabla_panel_a[9],'Constant','Constante')
tabla_panel_a = tabla_panel_a[c(-14)]
tabla_panel_a[14] = str_replace_all(tabla_panel_a[14],'Standard-Errors','Errores estándar')
tabla_panel_a[14] = str_replace_all(tabla_panel_a[14],'Heteroskedasticity-robust','HC1')
tabla_panel_a[15] = str_replace_all(tabla_panel_a[15],'Observations','Observaciones')
tabla_panel_a[16] = str_replace_all(tabla_panel_a[16],"Adjusted","Adj")
tabla_panel_a = tabla_panel_a[c(-18)]

##==: 5. Bind tables

tabla_panel = append(tabla_panel_a,
                     values = 'Panel A: Crecimiento de cuentas de depósitos en el \\\\ sistema financiero entre 2004 y 2010 y crecimiento \\\\ de acceso a créditos entre 2010 y 2023',
                     after = 4)

tabla_panel = append(tabla_panel,
                     values = "\\tabularnewline",
                     after = 5)

tabla_panel[19] = "   \\tabularnewline \\midrule \\midrule"

##==: 6. Save table

write_lines(tabla_panel,'05_mechanisms/output/03_regression_mechanism_cross_section_time_robustness.tex')
