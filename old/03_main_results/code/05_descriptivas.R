
rm(list = ls())
source("00_programs/00_packages.R")

# 01. Import
data = import("01_data/output/01_wb_global_findex_db_2025.rds") %>%  
        subset(year == 2024)  %>%  
        select(year, codewb, pop_adult , incomegroupwb24, group, account_t_d) %>%
        subset(group == "all") %>%  
        mutate(account_t_d = as.numeric(account_t_d),
               pop_adult = as.numeric(pop_adult))

fmi = import("01_data/output/01_imf_data.rds")

### 2.1 Filter for covariates
fmi = fmi %>%
      filter((indicator == 'Loan accounts, Commercial banks' & type_of_transformation == 'Number')|
               (indicator == 'Outstanding loans, Commercial banks' & type_of_transformation == 'Percent of GDP')|
               indicator == 'Number of deposit accounts, Commercial banks')

### 2.2 Remove add isocode
fmi = fmi %>%
      mutate(isocode = countrycode(country,origin = 'country.name',destination = 'iso3c')) %>%
      drop_na(isocode)

fmi = fmi %>%
      select(country, isocode, time_period, obs_value, indicator) %>%  
      subset(time_period == 2024) %>%
      mutate(indicator = case_when(indicator == "Loan accounts, Commercial banks" ~ "numero_cuentas_credito",
                                   indicator ==  "Outstanding loans, Commercial banks" ~ "monto_credito",
                                   indicator == "Number of deposit accounts, Commercial banks" ~ "numero_cuentas_ahorro"))

fmi = pivot_wider(fmi, values_from = obs_value, names_from = indicator)


poblacion_2024 = WDI(indicator = "SP.POP.TOTL",
                      start = 2024,
                      end = 2024) %>%
                  select(iso3c, country, population = SP.POP.TOTL)

fmi = fmi %>%  left_join(poblacion_2024, by = c("isocode" = "iso3c"))



fmi = fmi %>%
       mutate(numero_cuentas_credito = (numero_cuentas_credito/population)*1000)

countries= WDI::WDI_data$country %>%
            select(iso3c, income)

fmi = left_join(fmi, countries, by=c("isocode" = "iso3c"))

# descriptivas
dato1 = fmi %>%
        group_by(income) %>%
        summarise(mean_creditos = mean(numero_cuentas_credito, na.rm=T),
                  mean_ahorro = mean(numero_cuentas_ahorro, na.rm=T),
                  mean_monto = mean(monto_credito, na.rm=T))

export(dato1, "03_main_results/output/estadisticas.xlsx")