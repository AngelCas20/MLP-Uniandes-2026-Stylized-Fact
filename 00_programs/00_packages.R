### packages required
if(c("pacman") %in% installed.packages()[,1] == FALSE){
  install.packages("pacman")
  library(pacman)
  p_load(tidyverse,
         rio,
         janitor,
         data.table,
         ggpubr,
         knitr,
         kableExtra,
         countrycode)
}else{
  library(pacman)
  p_load(tidyverse,
         rio,
         janitor,
         data.table,
         ggpubr,
         knitr,
         kableExtra,
         countrycode)
}