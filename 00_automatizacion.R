## ================= ## 
##  Automatización   ##
## ================= ## 

rm(list = ls())
source("00_programs/00_packages.R")


#====== 01. lista de archivos de todo el repositorio: 
files_01 = list.files(path = "01_data/code/",
                   pattern = "\\.R$",
                   full.names = TRUE,
                   recursive = TRUE) 

files_02 = list.files(path = "02_wrangle/code/",
                   pattern = "\\.R$",
                   full.names = TRUE,
                   recursive = TRUE) 

files_03 = list.files(path = "03_main_results/code/",
                      pattern = "\\.R$",
                      full.names = TRUE,
                      recursive = TRUE) 

files_04 = list.files(path = "04_robustness/code/",
                      pattern = "\\.R$",
                      full.names = TRUE,
                      recursive = TRUE) 

files_05 = list.files(path = "05_mechanisms/code/",
                      pattern = "\\.R$",
                      full.names = TRUE,
                      recursive = TRUE) 

#====== 02.  correr todos los script:
files = c(files_01, files_02, files_03, files_04, files_05)

walk(files, function(x){source(x); gc()},.progress = T)