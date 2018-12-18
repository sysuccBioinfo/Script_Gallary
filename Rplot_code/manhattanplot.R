
﻿#采用ggplot2 绘制manhattanplot
library(reshape2)
library(ggplot2)
setwd("F:/mywork/project/Peng/SamtoolsResult/TotalEnronment/ChisqTest")
data<-read.table("forR.txt",header=T)
data2<-melt(data,id=c("sample","bp"))
names(data2)<-c("ID","BP","CHR","P")
l=unique(data2$CHR)
#定义颜色
data2$Color<- as.numeric(factor(data2$CHR,level=l))%%5
d=data2
#取负对数
d$P<--log10(d$P)
#我的样本
#把所有的位点分开，使得位点的横坐标在x轴上分开
name<-unique(d$CHR)
#循环数
fornumber<-length(name)-1
maxlength=4500000
for(i in 1:fornumber){
d[d$CHR==name[i+1],"BP"]<-d[d$CHR==name[i+1],"BP"]+max(d[d$CHR==name[i],"BP"])
}

	#人类数据命令 
	#for(i in 1:22){d[d$CHR==i+1,"BP"]<-d[d$CHR==i+1,"BP"]+max(d[d$CHR==i,"BP"])}

#每个染色体标注的坐标
for(i in 1:length(name)){
d[d$CHR==name[i],"Tick"]<-(min(d[d$CHR==name[i],"BP"])+max(d[d$CHR==name[i],"BP"]))/2
}

	#人类数据命令
	#for(j in 1:22){d[d$CHR==j, "Tick"] <- (min(d[d$CHR==j,"BP"]) + max(d[d$CHR==j,"BP"]))/2}

#绘图
ggplot(d, aes(BP, P))+
geom_point(size=1,aes(colour = as.factor(Color)))+
scale_color_brewer(palette = "Set1")+
ylab(expression(paste(-log[10]~"P value")))+
 theme_bw()+
theme(legend.position = "none",
                     panel.grid.major.x = element_blank(),
                     panel.grid.minor.x = element_blank()
                     ) +
 scale_x_continuous(name = "Antibiotics", 
                    breaks = unique(d$Tick),
                    labels = unique(d$CHR)
                    )
                    
#双向数据的（第二方向为虚拟）
# ggplot(d, aes(BP, P))+
#   geom_point(size=1,aes(colour = as.factor(Color)))+
#   geom_point(data=d, aes(BP, -P, 
#                          colour = as.factor(Color)),
#              size=1)+
#   geom_hline(yintercept = 0, size = 1)+
#   scale_color_brewer(palette = "Set1")+
#   ylab(expression(paste(-log[10]~"P value")))+
#   theme_bw()+
#   theme(legend.position = "none",
#         panel.grid.major.x = element_blank(),
#         panel.grid.minor.x = element_blank()
#   ) +
#   scale_x_continuous(name = "Chromosome", 
#                      breaks = unique(d$Tick),
#                      labels = unique(d$CHR)
#   ) +
#   scale_y_continuous(limits = c(-5,5), breaks = c(-5:5),
#                      labels = c(5:1, 0, 1:5))
                                       
                    

                                  
