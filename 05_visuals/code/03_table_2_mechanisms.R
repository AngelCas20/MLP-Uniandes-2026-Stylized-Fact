### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

mean_loss = import('04_mechanisms/output/04_distrust_on_banks_cross_section_mean_loss.rds',
                   setclass = "tibble")

sum_loss = import('04_mechanisms/output/04_distrust_on_banks_cross_section_sum_loss.rds',
                   setclass = "tibble")

##==: 2. Make tables

tabla = etable(mean_loss,
               sum_loss,
               drop = 'Constant',
               dict = c('number_accounts_1000_adults' = '$\\Delta$ Cuentas de depósitos \\\\ en el sistema financiero',
                        'mean_loss_gdp_per' = 'Pérdidas promedio de PIB per cápita \\\\ por crisis en el sistema financiero',
                        'sum_loss_gdp_per' = "Pérdidas acumuladas en el PIB per cápita \\\\ por crisis en el sistema financiero"),
               fitstat = ~ n + ar2,
               digits = 3,
               digits.stats = 3,
               tex = TRUE,
               se.row = TRUE) %>%
         as.character()

##==: 3. Prepare table

tabla[5] = str_replace_all(tabla[5],'Dependent Variable:',' ')
tabla[6] = str_replace_all(tabla[6],'Model:','Modelo:')
tabla[8] = ' '
tabla = tabla[c(-14,-15)]
tabla[13] = '\\tabularnewline'
tabla[14] = str_replace_all(tabla[14],'Observations','Observaciones')
tabla[15] = str_replace_all(tabla[15],"Adjusted","Adj")
tabla = tabla[c(-17,-18)]

tabla_panel = append(tabla,
                     values = 'Panel A: Crisis bancarias pasadas y crecimiento \\\\ de la bancarización en el presente',
                     after = 4)

tabla_panel = append(tabla_panel,
                     values = "\\tabularnewline",
                     after = 5)

tabla_panel[7] = "     & \\multicolumn{2}{c}{\\makecell{$\\Delta$ Cuentas de depósitos \\\\ en el sistema financiero}}\\\\"

tabla_panel = tabla_panel[c(-5,-6)]

##==: 4. Save table

write_lines(tabla_panel,'05_visuals/output/03_table_2_distrust_on_banks.tex')

