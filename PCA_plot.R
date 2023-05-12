library(data.table)
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)
library("ggsci")

args <- commandArgs(trailingOnly = TRUE)

#args[1] is the .eigenvec table
#args[2] is the .eigenval table
#args[3] is the Annus_state.csv table

#read tables
L <- sub("#", "", readLines(args[1]))
pca <- read.table(text = L, header = TRUE)
eigenval <- scan(args[2])
states <- read.table(args[3], sep=",", head=T)

#slelect Annus in PCA
pca_ann <- pca[pca$FID %like% "ANN", ]

#prepare states table
states_ch <- states[,c(4,9)]
states_ch_ann <-  states_ch[states_ch$Individuals %like% "ANN", ]
states_ch_ann$ranges <- gsub( "ANN", "", states_ch_ann$Individuals)
states_ch_ann <- states_ch_ann %>% separate(ranges, c("start","end"), sep = "([-])")
states_ch_ann$start <- as.numeric(states_ch_ann$start)
states_ch_ann$end <- as.numeric(states_ch_ann$end)
states_ch_ann_ready <- setDT(states_ch_ann)[ , list(State.or.Province = State.or.Province, Ind_number = seq(start, end)), by = 1:nrow(states_ch_ann)]
states_annus_listo <- states_ch_ann_ready[,c(2,3)]
states_annus_listo$Ind_number <-str_pad(states_annus_listo$Ind_number, 4, pad = "0")
states_annus_listo$Ind_number <- sub("^", "ANN", states_annus_listo$Ind_number )
colnames(states_annus_listo) <- c("State_or_Province", "IID")

#merge pca and states
pca_states <- merge(pca, states_annus_listo, by="IID")


jpeg("PCA_states_PASS.jpg")
ggplot(pca_states, aes(PC1, PC2, color=State_or_Province)) + geom_point(size = 3) + scale_fill_npg()
dev.off()

save.image("MAF05_PASS.Rdata")

#slelect individuals
library(ggplot2)
load("MAF05_PASS.Rdata")

Random_tex <- sample.int(nrow(pca_tex), 25)
Random_cal <- sample.int(nrow(pca_cal), 25)
Random_rest <- sample.int(nrow(pca_rest), 25)

highlight_tex <- pca_tex[Random_tex,]
highlight_cal <- pca_cal[Random_cal,]
highlight_rest <- pca_rest[Random_rest,]

jpeg("PCA_states_PASS_ind_selected.jpg")
ggplot(pca_states, aes(PC1, PC2, color=State_or_Province)) + geom_point(size = 3) +  geom_point(data=highlight_tex, aes(PC1, PC2), color='blue', size=3)  +  geom_point(data=highlight_cal, ae
s(PC1, PC2), color='red', size=3) +  geom_point(data=highlight_rest, aes(PC1, PC2), color='black', size=3)
dev.off()

highlight_tex_ordered <- highlight_tex[order(highlight_tex$IID),]
highlight_cal_ordered <- highlight_cal[order(highlight_cal$IID),]
highlight_rest_ordered <- highlight_rest[order(highlight_rest$IID),]
write.table(highlight_tex_ordered$IID, file="tex_selected.txt", col.names = F, row.names= F , quote = F)
write.table(highlight_cal_ordered$IID, file="cal_selected.txt", col.names = F, row.names= F , quote = F)
write.table(highlight_rest_ordered$IID, file="rest_selected.txt", col.names = F, row.names= F , quote = F)

save.image("MAF05_PASS.Rdata")

#selelect pops 
load("MAF05_PASS.Rdata")

pca_tex <- subset(pca_states, pca_states$PC1 < -0.04 & pca_states$State_or_Province == "Texas")
pca_cal <- subset(pca_states, pca_states$PC1 > 0.05 & pca_states$PC2 < -0.025)
pca_rest <- subset(pca_states, pca_states$PC1 > -0.012 &  pca_states$PC1 < 0.03 & pca_states$PC2 > 0.012)
#nrow(pca_rest)
#subset(pca_rest,  pca_cal$State_or_Province != "California")
#subset(pca_rest,  pca_cal$State_or_Province != "Texas")
#subset(pca_rest,  pca_cal$State_or_Province == "Texas")
#subset(pca_rest,  pca_cal$State_or_Province == "California")
#subset(pca_rest,  pca_rest$State_or_Province == "California")
#subset(pca_rest,  pca_rest$State_or_Province == "Texas")
#ls()
#pca_tex
#pca_cal
#pca_rest

save.image("MAF05_PASS.Rdata")


