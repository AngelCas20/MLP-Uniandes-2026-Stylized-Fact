### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')
source('00_programs/00_themes.R')

##==: 1. Load data

df = import('02_wrangle/output/01_processed_data.rds',
            setclass = 'tibble')

##==: 2. Convert variables to log
df = df %>% 
     mutate(across(.cols = c(gdp_per_capita,capital_per_capita,number_accounts_1000_adults),
                   .fns = log))

##==: 3. Run regression

model = feols(data = df,c(gdp_per_capita,capital_per_capita) ~ number_accounts_1000_adults|isocode + year)

##==: 4. Make table

tabla = etable(model,
               dict = c('number_accounts_1000_adults' = 'Depósitos en el \\\\ sistema financiero',
                        'gdp_per_capita' = "PIB per cápita",
                        'capital_per_capita' = 'Stock de Capital \nper cápita',
                        'isocode' = 'País',
                        'year' =  'Año'),
              fitstat = ~ n + awr2,
              digits = 3,
              tex = TRUE,
              se.row = TRUE
              ) %>% 
        as.character()

tabla[6] = str_replace_all(tabla[6],'Model:','Modelo:')
tabla[12] = str_replace_all(tabla[12],'Fixed-effects','Efectos fijos')
tabla = tabla[c(-16,-17)]

tabla[16] = str_replace_all(tabla[16],'Observations','Observaciones')
tabla[17] = str_replace_all(tabla[17],"Adjusted","Adj")

tabla = tabla[c(-19,-20)]


##==: 4. Save
write_lines(tabla,'03_compute/output/04_regression_table_fixed_effects.tex')
