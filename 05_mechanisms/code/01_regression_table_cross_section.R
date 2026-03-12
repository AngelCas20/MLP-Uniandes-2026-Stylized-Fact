### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/03_geometric_growth_mechanism.rds',
            setclass = 'tibble')

##==: 2. Run regression

### 2.1 Main variable on mechanisms

model_iid = feols(data = df,c(outstanding_loans_commercial_banks,loan_accounts_commercial_banks) ~ number_of_deposit_accounts_commercial_banks)

model_robust = feols(data = df,c(outstanding_loans_commercial_banks,loan_accounts_commercial_banks) ~ number_of_deposit_accounts_commercial_banks,se = 'hc1')

### 2.2 Mechanisms on Capital Stock

model_iid_1 = feols(data = df,capital_per_capita ~ loan_accounts_commercial_banks)
model_iid_2 = feols(data = df,capital_per_capita ~ outstanding_loans_commercial_banks)

model_robust_1 = feols(data = df,capital_per_capita ~ loan_accounts_commercial_banks,se = 'hetero')
model_robust_2 = feols(data = df,capital_per_capita ~ outstanding_loans_commercial_banks,se = 'hetero')

##==: 3. Make table

### 3.1 Panel A
tabla_panel_a = etable(model_iid,
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

### 3.2 Panel B
tabla_panel_b = etable(model_iid_1,model_robust_1,model_iid_2,model_robust_2,
                       dict = c('capital_per_capita' = '$\\Delta$ Stock de Capital per cápita',
                                'outstanding_loans_commercial_banks' = "$\\Delta$ Cuentas de créditos \\\\ en el sistema financiero",
                                'loan_accounts_commercial_banks' = '$\\Delta$ Cartera acumulada de créditos \\\\ en el sistema financiero'),
                       fitstat = ~ n + ar2,
                       digits = 3,
                       tex = TRUE,
                       se.row = TRUE
                      ) %>%
                as.character()

##==: 4. Prepare table

### 4.1 Prepare Panel A
tabla_panel_a[5] = str_replace_all(tabla_panel_a[5],'Dependent Variables:',' ')
tabla_panel_a[6] = str_replace_all(tabla_panel_a[6],'Model:','Modelo:')
tabla_panel_a[8] = ' '
tabla_panel_a[9] = str_replace_all(tabla_panel_a[9],'Constant','Constante')
tabla_panel_a = tabla_panel_a[c(-14)]
tabla_panel_a[14] = str_replace_all(tabla_panel_a[14],'Standard-Errors','Errores estándar')
tabla_panel_a[14] = str_replace_all(tabla_panel_a[14],'Heteroskedasticity-robust','HC1')
tabla_panel_a[15] = str_replace_all(tabla_panel_a[15],'Observations','Observaciones')
tabla_panel_a[16] = str_replace_all(tabla_panel_a[16],"Adjusted","Adj")
tabla_panel_a = tabla_panel_a[c(-18)]

### 4.2 Prepare Panel B

tabla_panel_b[5] = str_replace_all(tabla_panel_b[5],'Dependent Variable:',' ')
tabla_panel_b[6] = str_replace_all(tabla_panel_b[6],'Model:','Modelo:')
tabla_panel_b[8] = ' '
tabla_panel_b[9] = str_replace_all(tabla_panel_b[9],'Constant','Constante')
tabla_panel_b = tabla_panel_b[c(-16)]
tabla_panel_b[16] = str_replace_all(tabla_panel_b[16],'Standard-Errors','Errores estándar')
tabla_panel_b[16] = str_replace_all(tabla_panel_b[16],'Heteroskedasticity-robust','HC1')
tabla_panel_b[17] = str_replace_all(tabla_panel_b[17],'Observations','Observaciones')
tabla_panel_b[18] = str_replace_all(tabla_panel_b[18],"Adjusted","Adj")
tabla_panel_b = tabla_panel_b[c(-20)]

##==: 5. Bind tables

tabla_panel = append(tabla_panel_a,
                     values = 'Panel A: Crecimiento de cuentas de depósitos en el \\\\ sistema financiero y crecimiento de acceso a créditos',
                     after = 4)

tabla_panel = append(tabla_panel,
                     values = "\\tabularnewline",
                     after = 5)

tabla_panel[[19]] = "   \\tabularnewline \\midrule \\midrule"

tabla_panel = append(tabla_panel,
                     values = 'Panel B: Crecimiento de cuentas de depósitos en el \\\\ sistema financiero y crecimiento de acceso a créditos',
                     after = 19)

tabla_panel = append(tabla_panel,
                     values = "\\tabularnewline",
                     after = 20)

tabla_panel = append(tabla_panel,
                     values = tabla_panel_b[5:18],
                     after = 21)

tabla_panel = append(tabla_panel,
                     values = " \\midrule \\midrule",
                     after = 35)

tabla_panel = tabla_panel[-c(15,32)]

tabla_panel[15] = "   Errores estándar                                                       & IID           & IID & HC1           & HC1 \\\\   "

##==: 6. Save table

write_lines(tabla_panel,'05_mechanisms/output/01_regression_mechanism_cross_section.tex')
