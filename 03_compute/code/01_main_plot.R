### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')
source('00_programs/00_themes.R')

##==: 1. Load data

df = import('02_wrangle/output/01_geometric_growth.rds',
            setclass = 'tibble')

##==: 2. Make plots

### 2.1 Increase in financial inclusion vs capital per capita growth

p1 = ggplot(df)+
     geom_point(aes(x = share_adults_financial_account,
                    y = capital_per_capita),
                    size = 3.5,
                    col = 'midnightblue')+
     geom_smooth(aes(x = share_adults_financial_account,
                     y = capital_per_capita),
                     method = 'lm',
                     col = 'black')+
     tema+
     scale_x_continuous(labels = scales::percent,breaks = seq(0,0.3,0.05))+
     scale_y_continuous(labels = scales::percent,breaks = seq(-0.1,0.3,0.05))+
     labs(x = NULL,
          y = 'Crecimiento porcentual del \n Capital per capita (%)');p1

### 2.2 Increase in financial inclusion vs gdp per capita growth

p2 = ggplot(df)+
     geom_point(aes(x = share_adults_financial_account,
                    y = gdp_per_capita),
                    size = 3.5,
                    col = 'midnightblue')+
     geom_smooth(aes(x = share_adults_financial_account,
                     y = gdp_per_capita),
                     method = 'lm',
                     col = 'black')+
     tema+
     scale_x_continuous(labels = scales::percent,breaks = seq(0,0.3,0.05))+
     scale_y_continuous(labels = scales::percent,breaks = seq(-0.1,0.1,0.025))+
     labs(x = NULL,
          y = 'Crecimiento porcentual del \n PIB per capita (%)');p2

##==: 3. Merge plots

p3 = ggarrange(p1,p2);p3

model = lm(capital_per_capita ~ share_adults_financial_account,data = df) %>% 
  summary()

# Load the library
p_load(lmtest)

# Run the test
bptest(model)