## Code for data analysis 
library(ggplot2)

## Label names to copy and paste
# ~ alpha[1]
# ~ tau[m]
# ~ tau[1]
# ~ tau[2]

# Load appropriate data and separated into variables of control and cyanide 

plotData<-read.csv("D:/JoVE Paper 2021/8_10_ExperimentSingleCellDATA.csv")
control<-read.csv("D:/JoVE Paper 2021/8_10_Control.csv")
cyanide<-read.csv("D:/JoVE Paper 2021/8_10_Cyanide.csv")


# Creating y-axis name 

ylabel=expression("NAD(P)H" ~tau[m]~ "(ps)") 


# Plotting Whole image as box plot+adding scattered points into appropriate groups

cyanide_experiment<-ggplot(plotData, aes(x=label, y=NADH.FLIM)) 
  geom_jitter(shape=16, position=position_jitter(0.1),color = 'gray') +
  geom_boxplot(alpha = 0.3,outlier.shape=NA,outlier.size = 0,width = 0.4)+
  ylab(ylabel)+
  stat_summary(fun=mean, geom="point", shape=20, size=5, color="black", 
               fill="black")+
  theme(plot.margin = margin(2.5,1.2,2.5,1.2, "cm"),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(size = .2),
        axis.text.x = element_text(face = "bold",size = 28),
        axis.text.y = element_text(size = 20),
        axis.title.x = element_blank(),
        axis.title.y = element_text(face = "bold",size = 28))
  

# Saving plot and saving onto computer
  
ggsave(plot = cyanide_experiment, width = 10, height = 10, dpi = 300, 
       filename = "NADH tm.pdf") 


#Statistical Analysis to test for statistical significance 

t.test(control[, c('NADH.FLIM')], cyanide[, c('NADH.FLIM')], paired = FALSE)
