### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')
source('00_programs/00_themes.R')

##==: 1. Load data

df = import('02_wrangle/output/01_geometric_growth.rds',
            setclass = 'tibble')

##==: 2. Run regression

model_iid = feols(data = df,c(gdp_per_capita,capital_per_capita) ~ number_accounts_1000_adults)

model_robust = feols(data = df,c(gdp_per_capita,capital_per_capita) ~ number_accounts_1000_adults,se = 'hc1')

##==: 3. Make table

tabla = etable(model_iid,
               model_robust,
               dict = c('number_accounts_1000_adults' = 'Depósitos en el \\\\ sistema financiero',
                        'gdp_per_capita' = "PIB per cápita",
                        'capital_per_capita' = 'Stock de Capital \nper cápita'),
              fitstat = ~ n + ar2,
              digits = 3,
              tex = TRUE,
              se.row = TRUE
              ) %>%
        as.character()

tabla[6] = str_replace_all(tabla[6],'Model:','Modelo:')
tabla[9] = str_replace_all(tabla[9],'Constant','Constante')
tabla = tabla[c(-14)]
tabla[14] = str_replace_all(tabla[14],'Standard-Errors','Errores estándar')
tabla[14] = str_replace_all(tabla[14],'Heteroskedasticity-robust','HC1')
tabla[15] = str_replace_all(tabla[15],'Observations','Observaciones')
tabla[16] = str_replace_all(tabla[16],"Adjusted","Adj")

tabla = tabla[c(-18)]

##==: 4. Save
write_lines(tabla,'03_compute/output/03_regression_table_cross_section.tex')
