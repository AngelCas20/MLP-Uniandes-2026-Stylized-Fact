### save themes for plots

tema = theme_bw()+
       theme(legend.position = 'top',
             legend.text = element_text(size = 13),
             axis.title.x = element_text(size = 13),
             axis.title.y = element_text(size = 13),
             axis.text.x = element_text(size = 11,face = 'bold'),
             axis.text.y = element_text(size = 11,face = 'bold'),
             plot.title = element_text(size = 14))