### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')
source('00_programs/00_themes.R')

##==: 1. Load data

df = import('02_wrangle/output/01_geometric_growth.rds',
            setclass = 'tibble')

##==: 2. Subset data

df = df %>% 
     filter(isocode != 'VEN') ### Remove Venezuela from dataset

##==: 3. Make plots

### 3.1 Increase in financial inclusion vs capital per capita growth
p1 = ggplot(df)+
     geom_point(aes(x = share_adults_financial_account,
                    y = capital_per_capita),
                    size = 3.5,
                    col = 'darkgreen')+
     geom_smooth(aes(x = share_adults_financial_account,
                     y = capital_per_capita),
                     method = 'lm',
                     col = 'black')+
     tema+
     scale_x_continuous(labels = scales::percent,breaks = seq(0,0.3,0.05))+
     scale_y_continuous(labels = scales::percent,breaks = seq(-0.1,0.3,0.025))+
     labs(x = NULL,
          y = 'Crecimiento del Capital per capita (%)',
          title = 'Panel A: Crecimiento del acceso al sistema financiero vs \ncrecimiento del Stock de Capital per cápita');p1

### 3.2 Increase in financial inclusion vs gdp per capita growth

p2 = ggplot(df)+
     geom_point(aes(x = share_adults_financial_account,
                    y = gdp_per_capita),
                    size = 3.5,
                    col = 'darkgreen')+
     geom_smooth(aes(x = share_adults_financial_account,
                     y = gdp_per_capita),
                     method = 'lm',
                     col = 'black')+
     tema+
     scale_x_continuous(labels = scales::percent,breaks = seq(0,0.3,0.05))+
     scale_y_continuous(labels = scales::percent,breaks = seq(-0.1,0.1,0.025))+
     labs(x = NULL,
          y = 'Crecimiento del PIB per capita (%)',
          title = 'Panel B: Crecimiento del acceso al sistema financiero vs \ncrecimiento del PIB per cápita');p2

##==: 4. Merge plots

p3 = ggarrange(p1,p2);p3

p3 = annotate_figure(p3,
                bottom = textGrob("Crecimiento del porcentaje de la \npoblación con acceso al sistema financiero (%)", gp = gpar(cex = 1.3)))

##==: 5. Export data

ggsave(p3,filename = '03_compute/output/01_main_plot.pdf',width = 14,height = 8)
