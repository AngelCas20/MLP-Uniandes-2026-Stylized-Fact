### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')
source('00_programs/00_themes.R')

##==: 1. Load data

df = import('02_wrangle/output/01_geometric_growth.rds',
            setclass = 'tibble')

##==: 2. Run regression

model_iid = feols(data = df,c(gdp_per_capita,capital_per_capita) ~ share_adults_financial_account)

model_robust = feols(data = df,c(gdp_per_capita,capital_per_capita) ~ share_adults_financial_account,se = 'hc1')

##==: 3. Make table

tabla = etable(model_iid,
               model_robust,
               dict = c('share_adults_financial_account' = 'Acceso al sistema \\\\ financiero formal',
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
tabla[14] = "   \\midrule" 
tabla[15] = str_replace_all(tabla[15],'Standard-Errors','Errores estándar')
tabla[15] = str_replace_all(tabla[15],'Heteroskedasticity-robust','HC1')
tabla[16] = str_replace_all(tabla[16],'Observations','Observaciones')
tabla[17] = str_replace_all(tabla[17],"Adjusted","Adj")

tabla = tabla[c(-19)]

##==: 4. Save
write_lines(tabla,'03_compute/output/03_regression_table.tex')
