### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

df = import('02_wrangle/output/01_processed_data.rds',
            setclass = 'tibble')

##==: 2. Wrangle data

### 2.1 Convert variables to log

df = df %>% 
     mutate(across(.cols = c(gdp_per_capita,capital_per_capita,number_accounts_1000_adults),
                   .fns = log))

unique_countries = df$isocode %>% unique() %>% length()

### 2.2 Subset data to before 2019
df = df %>% filter(year <= 2019)

##==: 3. Run regression

model = feols(data = df,c(gdp_per_capita,capital_per_capita) ~ number_accounts_1000_adults|isocode + year)

##==: 4. Make table

tabla = etable(model,
               dict = c('number_accounts_1000_adults' = 'ln(Cuentas de depósitos \\\\ en el sistema financiero)',
                        'gdp_per_capita' = "ln(PIB per cápita)",
                        'capital_per_capita' = 'ln(Stock de Capital \nper cápita)',
                        'isocode' = 'País',
                        'year' =  'Año'),
              fitstat = ~ n + awr2,
              digits = 3,
              digits.stats = 3,
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

tabla = append(tabla,paste0('Países & ',unique_countries,' & ',unique_countries,' \\\\ '),after = 16)

##==: 4. Save
write_lines(tabla,'04_robustness/output/03_regression_table_fixed_effects_robust.tex')
