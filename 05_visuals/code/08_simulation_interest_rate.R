### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')
source('00_programs/00_themes.R')

##==: 1. Simulate parameters

delta = 0.05
rho = 0.07  
p = seq(0,0.99,0.01)

##==: 2. Construct dataframe

data = tibble(p = p,r_t = delta + (rho/(1 - p)))

##==: 3. Make plot

p1 = ggplot(data = data)+
     geom_line(aes(x = p,y = r_t),linewidth = 3.5,linetype = 'dashed')+
     scale_y_log10()+
     labs(title = NULL,x = NULL,y = NULL) +
     tema +
     theme(axis.text.x = element_text(size = 20),
           axis.text.y = element_blank(),
           axis.ticks = element_blank(),
           legend.title = element_text(size =  25),
           legend.text = element_text(size =  25));p1

###== 4. Export plot

ggsave(p1,filename = "05_visuals/output/08_simulation_steady_state_interest_rate.pdf",width = 14,height = 8)
