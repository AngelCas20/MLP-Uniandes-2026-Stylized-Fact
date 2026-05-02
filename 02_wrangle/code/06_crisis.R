### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')


# === 01. importar:

cris = import("01_data/output/01_cris_data.rds")

imf = import('01_data/output/01_imf_data.rds',
             setclass = 'tibble') 

pwt = import('01_data/output/01_pwt110.rds',
             setclass = 'tibble')

# === 02. preparar:  
cris = cris %>%  mutate(country = str_remove(country, "\\s\\d+/\\s*$"), 
                        end = str_remove(end, "\\s\\d+/\\s*$"),  
                        end = as.numeric(end),
                        end = ifelse(is.na(end), 2015, end),
                        duracion = end - start,
                        duracion = ifelse(duracion == 0, 1, duracion),
                        across(c(output_loss_1, fiscal_costs_2_percent_of_gdp,
                                  fiscal_costs_net_2_percent_of_gdp,
                                  fiscal_cost_percent_of_financial_sector_assets,
                                  peak_liquidity_3,
                                  liquidity_support_3,
                                  peak_np_ls_4,
                                  increase_in_public_debt_5),
                                ~ as.numeric(.)))

cris = cris %>% 
        mutate(isocode = countrycode(country,origin = 'country.name',destination = 'iso3c')) %>%  subset(!is.na(isocode) & !is.na(output_loss_1))

pwt = pwt %>% 
      mutate(gdp_per_capita = rgdpna/pop) %>% 
      select(year,isocode = countrycode,country,gdp_per_capita,rgdpna, pop ) %>% 
      arrange(isocode,year) 


cris = left_join(cris, pwt, by=c("start" = "year", "isocode")) %>% 
       mutate(loss_gdp_per = output_loss_1 * gdp_per_capita, 
              gdp_per_capita_sin_crisis = loss_gdp_per + gdp_per_capita,
              output_loss_abs = rgdpna * (output_loss_1 / 100),
              output_loss_per_1000 = (output_loss_abs / pop) * 1000,
              prop = (gdp_per_capita - gdp_per_capita_sin_crisis) / gdp_per_capita_sin_crisis) %>%  
        group_by(isocode) %>%  
        summarise(mean_duracion = sum(duracion), 
                  mean_prop = mean(prop), 
                  mean_loss_gdp_per = mean(loss_gdp_per), 
                  sum_loss_gdp_per = sum(loss_gdp_per), 
                  n_crisis = n(), 
                  output_loss_per_1000 = sum(output_loss_per_1000))

imf = imf %>% 
      select(country,indicator,type_of_transformation,year = time_period,value = obs_value) %>% 
      filter(str_detect(indicator,'Number of deposit accounts, Commercial banks')) %>% 
      filter(str_detect(indicator,'Households')==F) 


imf = imf %>% 
      mutate(isocode = countrycode(country,origin = 'country.name',destination = 'iso3c')) %>% 
      drop_na(year,value,isocode) 

imf = imf %>% 
       select(year,isocode,number_accounts_1000_adults = value)

interest_period = c(2004, 2023)


geometric_growth = imf %>% 
                  filter(year %in% interest_period) 
time_diff = diff(interest_period)


geometric_growth = geometric_growth %>% 
            filter(year %in% interest_period) %>% 
            group_by(isocode) %>% 
            filter(n() == 2) %>% 
            ungroup()
          
 
geometric_growth = geometric_growth %>% 
                    group_by(isocode) %>% 
                    summarise(across(.cols = c(number_accounts_1000_adults),
                                     .fns = function(x){
                                       x = (x/lag(x))^(1/time_diff) -1
                                       x = max(x,na.rm = T)
                                     })) %>% 
                    ungroup()


# check regression: 
data = inner_join(geometric_growth, cris, by = c("isocode")) %>%  drop_na()


export(data, "02_wrangle/output/06_datos_crisis.rds")

# model_iid = feols(data = data, number_accounts_1000_adults ~ asinh(mean_prop), se = "hetero"); etable(model_iid)
# model_iid = feols(data = data, number_accounts_1000_adults ~ asinh(mean_loss_gdp_per), se = "hetero"); etable(model_iid)
# model_iid = feols(data = data, number_accounts_1000_adults ~ asinh(sum_loss_gdp_per), se = "hetero"); etable(model_iid)
# model_iid = feols(data = data, number_accounts_1000_adults ~ n_crisis, se = "hetero"); etable(model_iid)
# model_iid = feols(data = data, number_accounts_1000_adults ~ asinh(output_loss_per_1000), se = "hetero"); etable(model_iid)
