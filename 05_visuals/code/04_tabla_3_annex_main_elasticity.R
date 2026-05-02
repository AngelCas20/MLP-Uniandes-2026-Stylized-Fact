### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

### 1.1 Full sample data
full_sample_panel_a = import('03_main_regression/output/01_main_regression_cross_section.rds')

### 1.2 Censored sample data
censored_sample_panel_a = import('03_main_regression/output/02_main_regression_cross_section_long_run.rds')

## 1.3 Panel data
panel_data_panel_a = import('03_main_regression/output/03_main_regression_panel_data.rds')

##==: 2. Make tables

### 2.1 Panel A
tabla_panel_a = etable(full_sample_panel_a,
                       censored_sample_panel_a,
                       drop = 'Constant',
                       dict = c('number_accounts_1000_adults' = '$\\Delta$ Cuentas de depósitos \\\\ en el sistema financiero',
                                'gdp_per_capita' = "$\\Delta$ PIB per cápita",
                                'capital_per_capita' = '$\\Delta$ Stock de Capital \nper cápita'),
                       fitstat = ~ n + ar2,
                       digits = 3,
                       digits.stats = 3,
                       tex = TRUE,
                       se.row = TRUE) %>%
                as.character()

##==: 3. Prepare table

tabla_panel_a[5] = str_replace_all(tabla_panel_a[5],'Dependent Variables:',' ')
tabla_panel_a[6] = str_replace_all(tabla_panel_a[6],'Model:','Modelo:')
tabla_panel_a[8] = ' '
tabla_panel_a = tabla_panel_a[c(-12,-13)]
tabla_panel_a[12] = str_replace_all(tabla_panel_a[12],'Observations','Observaciones')
tabla_panel_a[13] = str_replace_all(tabla_panel_a[13],"Adjusted","Adj")
tabla_panel_a = tabla_panel_a[c(-15,-16)]
tabla_panel_a[11] = "\\tabularnewline"

tabla_panel_a = append(tabla_panel_a,
                       values = 'Horizonte temporal & Completo & Completo & Restringido & Restringido \\\\  ',
                       after = 13)

##==: 4. Save table

write_lines(tabla_panel_a,'05_visuals/output/04_tabla_3_annex_main_elasticity.tex')
