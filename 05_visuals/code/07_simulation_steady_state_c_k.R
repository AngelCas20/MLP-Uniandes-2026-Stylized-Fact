### setup
cat("\f")
rm(list = ls())
source('00_programs/00_packages.R')
source('00_programs/00_themes.R')

###== 1. Simulation paramters 

alpha <- 0.33
rho   <- 0.07  
delta <- 0.05
A     <- 1   
d_max <- 0.6  
ps    <- c(0, 0.3, 0.6, 0.9)

###== 2. Comppute values

get_equilibrium <- function(p) {
  d <- p * d_max
  k_star <- ((delta + rho/(1-d)) / (alpha * A))^(1 / (alpha - 1))
  c_star <- A * k_star^alpha * (1 - d * alpha) - delta * k_star * (1 - d)
  return(data.frame(p = as.character(p), k_star = k_star, c_star = c_star, d = d))
}

equilibrios <- do.call(rbind, lapply(ps, get_equilibrium))

k_seq <- seq(0.01, 10, length.out = 300)
curvas_k <- do.call(rbind, lapply(ps, function(p_val) {
  d_val <- p_val * d_max
  data.frame(
    k = k_seq,
    c = A * k_seq^alpha * (1 - d_val * alpha) - delta * k_seq * (1 - d_val),
    p = as.character(p_val)
  )
}))

###== 3. Make plot

p1 = ggplot() +
     geom_line(data = curvas_k, aes(x = k, y = c, color = p, linetype = p == "0"), size = 2) +
     geom_vline(data = equilibrios, aes(xintercept = k_star, color = p, linetype = p == "0"), size = 3) +
     geom_point(data = equilibrios, aes(x = k_star, y = c_star, color = p), size = 2) +
     scale_color_manual(values = c("0" = "#2c3e50", "0.3" = "#f39c12", "0.6" = "#00a135", "0.9" = "#c0392b"),
                        name = "Probabilidad (p)") +
     scale_linetype_manual(values = c("TRUE" = "solid", "FALSE" = "dashed"), guide = "none") +
     labs(title = NULL,x = NULL,y = NULL) +
     tema +
     xlim(0, 7) + ylim(0, 2) +
     theme(axis.text.x = element_blank(),
           axis.text.y = element_blank(),
           axis.ticks = element_blank(),
           legend.title = element_text(size =  25),
           legend.text = element_text(size =  25));p1

###== 4. Export plot

ggsave(p1,filename = "05_visuals/output/07_simulation_steady_state_c_k.pdf",width = 14,height = 8)
