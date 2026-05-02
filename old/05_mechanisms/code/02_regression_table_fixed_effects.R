### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/03_processed_data_mechanism.rds',
            setclass = 'tibble')

##==: 2. Wrangle data

### 2.1 Convert level variables to log

df = df %>% 
     mutate(across(.cols = c(capital_per_capita,
                             number_of_deposit_accounts_commercial_banks),
                   .fns = log))

### 2.2 Get unique number of countries for estimation

unique_countries = df$isocode %>% unique() %>% length()

##==: 3. Run regression

model_panel_a = feols(data = df,outstanding_loans_commercial_banks ~ number_of_deposit_accounts_commercial_banks|isocode + year)

model_panel_b = feols(data = df,capital_per_capita ~ outstanding_loans_commercial_banks|isocode + year)

##==: 4. Make table

### 4.1 Panel A
tabla_panel_a = etable(model_panel_a,
                       dict = c("number_of_deposit_accounts_commercial_banks" = 'ln(Cuentas de depósitos \nen el sistema financiero)',
                                'outstanding_loans_commercial_banks' = "Valor de créditos vigentes \n en el sistema financiero como \\% del PIB",
                                'isocode' = 'País',
                                'year' =  'Año'),
                       fitstat = ~ n + awr2,
                       digits = 3,
                       digits.stats = 3,
                       tex = TRUE,
                       se.row = TRUE
                      ) %>% 
                as.character()

### 4.1 Panel B
tabla_panel_b = etable(model_panel_b,
                       dict = c('capital_per_capita' = 'ln(Stock de Capital \nper cápita)',
                                'outstanding_loans_commercial_banks' = "Valor de créditos vigentes \n en el sistema financiero como \\% del PIB",
                                'isocode' = 'País',
                                'year' =  'Año'),
                       fitstat = ~ n + awr2,
                       digits = 3,
                       digits.stats = 3,
                       tex = TRUE,
                       se.row = TRUE
                      ) %>% 
                as.character()

##==: 5. Prepare table

### 5.1 Prepare panel A
tabla_panel_a[5] = str_replace_all(tabla_panel_a[5],'Dependent Variable:',' ')
tabla_panel_a[6] = str_replace_all(tabla_panel_a[6],'Model:','Modelo:')
tabla_panel_a[8] = ' '
tabla_panel_a[12] = str_replace_all(tabla_panel_a[12],'Fixed-effects','Efectos fijos')
tabla_panel_a[13] = str_replace_all(tabla_panel_a[13],'Yes','\\\\checkmark')
tabla_panel_a[14] = str_replace_all(tabla_panel_a[14],'Yes','\\\\checkmark')
tabla_panel_a = tabla_panel_a[c(-16,-17)]
tabla_panel_a[16] = str_replace_all(tabla_panel_a[16],'Observations','Observaciones')
tabla_panel_a[17] = str_replace_all(tabla_panel_a[17],"Adjusted","Adj")
tabla_panel_a = tabla_panel_a[c(-19,-20)]
tabla_panel_a = append(tabla_panel_a,paste0('Países & ',unique_countries,' \\\\ '),after = 16)

### 5.2 Prepare Panel B
tabla_panel_b[5] = str_replace_all(tabla_panel_b[5],'Dependent Variable:',' ')
tabla_panel_b[6] = str_replace_all(tabla_panel_b[6],'Model:','Modelo:')
tabla_panel_b[8] = ' '
tabla_panel_b[12] = str_replace_all(tabla_panel_b[12],'Fixed-effects','Efectos fijos')
tabla_panel_b[13] = str_replace_all(tabla_panel_b[13],'Yes','\\\\checkmark')
tabla_panel_b[14] = str_replace_all(tabla_panel_b[14],'Yes','\\\\checkmark')
tabla_panel_b = tabla_panel_b[c(-21,-22)]
tabla_panel_b[18] = str_replace_all(tabla_panel_b[18],'Observations','Observaciones')
tabla_panel_b[19] = str_replace_all(tabla_panel_b[19],"Adjusted","Adj")
tabla_panel_b = tabla_panel_b[c(-16,-17)]
tabla_panel_b = append(tabla_panel_b,paste0('Países & ',unique_countries,' \\\\ '),after = 16)

##==: 6. Bind tables

tabla_panel = append(tabla_panel_a,
                     values = 'Panel A: Crecimiento de cuentas de depósitos en el \\\\ sistema financiero y crecimiento de acceso a créditos',
                     after = 4)

tabla_panel = append(tabla_panel,
                     values = "\\tabularnewline",
                     after = 5)

tabla_panel[21] = "   \\tabularnewline \\midrule \\midrule"

tabla_panel = append(tabla_panel,
                     values = 'Panel B: Crecimiento de cuentas de depósitos en el \\\\ sistema financiero y crecimiento de acceso a créditos',
                     after = 21)

tabla_panel = append(tabla_panel,
                     values = "\\tabularnewline",
                     after = 22)

tabla_panel = append(tabla_panel,
                     values = tabla_panel_b[5:18],
                     after = 23)

tabla_panel = append(tabla_panel,
                     values = " \\midrule \\midrule",
                     after = 37)

##==: 7. Save table

write_lines(tabla_panel,'05_mechanisms/output/02_regression_mechanism_panel_fe.tex')
