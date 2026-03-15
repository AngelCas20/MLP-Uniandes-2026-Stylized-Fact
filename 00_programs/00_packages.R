### packages required
pkgs = c("tidyverse",
         "rio",
         "janitor",
         "data.table",
         "ggpubr",
         "knitr",
         "kableExtra",
         "countrycode",
         "fixest",
         "grid",
         "snakecase",
         "panelsummary", 
         "WDI")

### Instal pacman if not available
if(c("pacman") %in% installed.packages()[,1] == FALSE){
  install.packages("pacman")
  library(pacman)
  p_load(char = pkgs,character.only = TRUE)
}else{
  library(pacman)
  p_load(char = pkgs,character.only = TRUE)
}