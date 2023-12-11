#this table has genetic distances and physical positions
Pos <- read.table("Table_For_Marey_names.txt", header=T)

#this table has values increasing every 500bp, from 0 to the legth of each chromosome 
Pos_500kb <- read.table("Table_with_pos_to_getRR_500kb.txt", head =T)

#to loop over all chromosomes
#for(chr in unique(Pos$map)) {
for(chr in c("HanXRQChr01", "HanXRQChr02", "HanXRQChr08", "HanXRQChr09")) {

Pos2 <- subset(Pos, Pos$map==chr)

#a first filter to eliminate crazy outliers using the residuals
spline <- smooth.spline(x = Pos2$phys, y = Pos2$gen, spar = 0.3)
Pos2_R <-  cbind(Pos2, R=residuals(spline))
Pos2_R_F1 <- subset(Pos2_R, Pos2_R$R > -1 & Pos2_R$R < 1)

#then, eliminate values that break the monotonic increase

while (any(diff(Pos2_R_F1$gen) < 0)) {
        violations <- which(diff(Pos2_R_F1$gen) < 0) + 1

        Pos2_R_F1 <- Pos2_R_F1[-violations, ]
        }

#a second filter to eliminate outliers after I fit a second cubic spline

spline2 <- smooth.spline(Pos2_R_F1$phys, Pos2_R_F1$gen, spar = 0.3)
Pos2_R_F1_R2 <- cbind(Pos2_R_F1, R2=residuals(spline2))
Pos2_R_F1_R2_F2 <- subset(Pos2_R_F1_R2, Pos2_R_F1_R2$R2 > -0.1 & Pos2_R_F1_R2$R2 < 0.1)

#creating the cubic spline I'll use to report RR
spline3 <- smooth.spline(Pos2_R_F1_R2_F2$phys, Pos2_R_F1_R2_F2$gen, spar = 0.3)

#file with pos every 500kb
Pos_500kb_2 <- subset(Pos_500kb, Pos_500kb$map==chr)

#obtaining the first derivative (RR)
X_derivatives_500kb <- predict(spline3, Pos_500kb_2$phys, deriv = 1)$y

#converting cm/bp to cm/Mb
Pos_500kb_2_der <- cbind(Pos_500kb_2, RR=X_derivatives_500kb * 1e6)

#setting to 0 negative values
Pos_500kb_2_der$RR[Pos_500kb_2_der$RR < 0] <- 0


jpeg(paste(chr , "RR.jpg", sep= "_"))
plot(Pos_500kb_2_der$phys, Pos_500kb_2_der$RR)
lines(smooth.spline(Pos_500kb_2_der$phys, Pos_500kb_2_der$RR, spar =0.3), col="blue")
dev.off()

jpeg(paste(chr , "Marey.jpg", sep= "_"))
plot(Pos2_R_F1_R2_F2$phys, Pos2_R_F1_R2_F2$gen)
lines(smooth.spline(Pos2_R_F1_R2_F2$phys, Pos2_R_F1_R2_F2$gen, spar =0.3), col="red")    
dev.off()

write.table(Pos_500kb_2_der, paste(chr ,"500Kb_RR_filtered.txt", sep = "_"), quote = F,  row.names = F)


}
