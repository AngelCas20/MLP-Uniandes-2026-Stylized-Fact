### save themes for plots

tema = theme_bw()+
       theme(legend.position = 'top',
             legend.text = element_text(size = 14),
             axis.title.x = element_text(size = 14),
             axis.title.y = element_text(size = 14),
             axis.text.x = element_text(size = 14,face = 'bold'),
             axis.text.y = element_text(size = 14,face = 'bold'),
             plot.title = element_text(size = 17))