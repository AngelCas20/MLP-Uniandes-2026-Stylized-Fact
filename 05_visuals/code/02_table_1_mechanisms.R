### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

### 1.1 Full sample data
full_sample_panel_a = import('04_mechanisms/output/01_mechanism_cross_section_banking_on_mechanism.rds')
full_sample_panel_b = import('04_mechanisms/output/01_mechanism_cross_section_capital_on_mechanism.rds')

### 1.2 Censored sample data
censored_sample_panel_a = import('04_mechanisms/output/02_mechanism_cross_section_banking_on_mechanism_long_run.rds')
censored_sample_panel_b = import('04_mechanisms/output/02_mechanism_cross_section_capital_on_mechanism_long_run.rds')

##==: 2. Make tables

### 2.1 Panel A
tabla_panel_a = etable(full_sample_panel_a,
                       censored_sample_panel_a,
                       drop = 'Constant',
                       dict = c('number_of_deposit_accounts_commercial_banks' = '$\\Delta$ Cuentas de depósitos \\\\ en el sistema financiero',
                                'outstanding_loans_commercial_banks' = "$\\Delta$ Valor de créditos vigentes \n en el sistema financiero como \\% del PIB"),
                       fitstat = ~ n + ar2,
                       digits = 3,
                       digits.stats = 3,
                       tex = TRUE,
                       se.row = TRUE) %>%
                as.character()

### 2.2 Panel B
tabla_panel_b = etable(full_sample_panel_b,
                       censored_sample_panel_b,
                       drop = 'Constant',
                       dict = c('capital_per_capita' = '$\\Delta$ Stock de Capital per cápita',
                                'outstanding_loans_commercial_banks' = "$\\Delta$ Valor de créditos vigentes \n en el sistema financiero como \\% del PIB"),
                       fitstat = ~ n + ar2,
                       digits = 3,
                       digits.stats = 3,
                       tex = TRUE,
                       se.row = TRUE) %>%
                as.character()

##==: 3. Prepare table

### 3.1 Prepare Panel A
tabla_panel_a[5] = str_replace_all(tabla_panel_a[5],'Dependent Variable:',' ')
tabla_panel_a[6] = str_replace_all(tabla_panel_a[6],'Model:','Modelo:')
tabla_panel_a[8] = ' '
tabla_panel_a = tabla_panel_a[c(-12,-13)]
tabla_panel_a[12] = str_replace_all(tabla_panel_a[12],'Observations','Observaciones')
tabla_panel_a[13] = str_replace_all(tabla_panel_a[13],"Adjusted","Adj")
tabla_panel_a = append(tabla_panel_a,
                       values = 'Horizonte temporal & Completo & Restringido \\\\  ',
                       after = 13)

### 3.2 Prepare Panel B
tabla_panel_b[5] = str_replace_all(tabla_panel_b[5],'Dependent Variable:',' ')
tabla_panel_b[6] = str_replace_all(tabla_panel_b[6],'Model:','Modelo:')
tabla_panel_b[8] = ' '
tabla_panel_b = tabla_panel_b[c(-12,-13)]
tabla_panel_b[12] = str_replace_all(tabla_panel_b[12],'Observations','Observaciones')
tabla_panel_b[13] = str_replace_all(tabla_panel_b[13],"Adjusted","Adj")
tabla_panel_b = append(tabla_panel_b,
                       values = 'Horizonte temporal & Completo & Restringido \\\\  ',
                       after = 13)

##==: 4. Bind tables together

tabla_panel = append(tabla_panel_a[1:15],
                     values = 'Panel A: Crecimiento de cuentas de depósitos en el \\\\ sistema financiero y crecimiento de acceso a créditos',
                     after = 4)

tabla_panel = append(tabla_panel,
                     values = "\\tabularnewline",
                     after = 5)

tabla_panel[17] = "   \\tabularnewline \\midrule \\midrule"

tabla_panel = append(tabla_panel,
                     values = 'Panel B: Crecimiento de montos de créditos como  \\\\ \\% del PIB y crecimiento del Stock de Capital',
                     after = 17)

tabla_panel = append(tabla_panel,
                     values = "\\tabularnewline",
                     after = 18)

tabla_panel = append(tabla_panel,
                     values = c(tabla_panel_b[5:15],tabla_panel_b[18:19]),
                     after = 19)

tabla_panel[13] = '\\tabularnewline'
tabla_panel[26] = '\\tabularnewline'

##==: 5. Save table

write_lines(tabla_panel,'05_visuals/output/02_table_1_mechanisms.tex')
