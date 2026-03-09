#------------------------#
# Angel Castillo Negrete #
#    2026 - 03 - 07      #
#------------------------#

### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')

##==: 1. Load data

dict_pwt = import('01_data/input/pwt110.xlsx',
                   setclass = 'tibble',
                   sheet = 2) %>% 
            clean_names() %>% 
            drop_na(variable_name)

pwt = import('01_data/input/pwt110.xlsx',
             setclass = 'tibble',
             sheet = 3) %>% 
            clean_names() 

wb = import('01_data/input/GlobalFindexDatabase2025.xlsx',
            setclass = 'tibble',
            sheet = 2) %>% 
            clean_names() 

imf = import('01_data/input/dataset_2026-03-08T23_46_47.042512374Z_DEFAULT_INTEGRATION_IMF.STA_FAS_4.0.0.rds',
            setclass = 'tibble') %>% 
            clean_names() 

##==: 2. Export data
export(wb,'01_data/output/01_wb_global_findex_db_2025.rds')
export(pwt,'01_data/output/01_pwt110.rds')
export(imf,'01_data/output/dataset_2026-03-08T23_46_47.042512374Z_DEFAULT_INTEGRATION_IMF.STA_FAS_4.0.0.rds')
