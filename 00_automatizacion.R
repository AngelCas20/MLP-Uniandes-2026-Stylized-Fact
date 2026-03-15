## ================= ## 
##  Automatización   ##
## ================= ## 

rm(list = ls())
source("00_programs/00_packages.R")


#====== 01. lista de archivos de todo el repositorio: 
files = list.files(path = "../MLP-Uniandes-2026-Stylized-Fact/",
                   pattern = "\\.R$",
                   full.names = TRUE,
                   recursive = TRUE) %>% 
         .[str_detect(string = ., pattern = "00_automatizacion.R|00_packages.R|00_themes.R", negate = T)] 

#====== 02.  correr todos los script:
walk(files, function(x){source(x); gc()},.progress = T)

