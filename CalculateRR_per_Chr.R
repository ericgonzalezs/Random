Pos <- read.table("Table_For_Marey_names.txt", header=T)
Pos_500kb <- read.table("Table_with_pos_to_getRR_500kb.txt", head =T)


#for(chr in unique(Pos$map)) {
for(chr in c("HanXRQChr01", "HanXRQChr02", "HanXRQChr08", "HanXRQChr09")) {

Pos2 <- subset(Pos, Pos$map==chr)

#a first filter to eliminate crazy outliers using the residuals
spline <- smooth.spline(x = Pos2$phys, y = Pos2$gen, spar = 0.05)
Pos2_R <-  cbind(Pos2, R=residuals(spline))
Pos2_R_F1 <- subset(Pos2_R, Pos2_R$R > -1 & Pos2_R$R < 1)

#then, eliminate values that break the monotonic increase

while (any(diff(Pos2_R_F1$gen) < 0)) {
        violations <- which(diff(Pos2_R_F1$gen) < 0) + 1

        Pos2_R_F1 <- Pos2_R_F1[-violations, ]
        }

#a second filter to eliminate outliers after I fit a second cubic spline

spline2 <- smooth.spline(Pos2_R_F1$phys, Pos2_R_F1$gen, spar = 0.05)
Pos2_R_F1_R2 <- cbind(Pos2_R_F1, R2=residuals(spline2))

Pos2_R_F1_R2_F2 <- subset(Pos2_R_F1_R2, Pos2_R_F1_R2$R2 > -0.1 & Pos2_R_F1_R2$R2 < 0.1)

#creating the curve I'll use to report RR
spline3 <- smooth.spline(Pos2_R_F1_R2_F2$phys, Pos2_R_F1_R2_F2$gen, spar = 0.05)

#file with pos every 500kb
Pos_500kb_2 <- subset(Pos_500kb, Pos_500kb$map==chr)

#obtaining the first derivative
X_derivatives_500kb <- predict(spline3, Pos_500kb_2$phys, deriv = 1)$y

#converting bp to Mb
Pos_500kb_2_der <- cbind(Pos_500kb_2, RR=X_derivatives_500kb * 1e6)

#setting to 0 negative values
Pos_500kb_2_der$RR[Pos_500kb_2_der$RR < 0] <- 0


jpeg(paste(chr , "RR.jpg", sep= "_"))
plot(Pos_500kb_2_der$phys, Pos_500kb_2_der$RR)
dev.off()

jpeg(paste(chr , "Marey.jpg", sep= "_"))
plot(Pos2_R_F1_R2_F2$phys, Pos2_R_F1_R2_F2$gen)
dev.off()

write.table(Pos_500kb_2_der, paste(chr ,"500Kb_RR_filtered.txt", sep = "_"), quote = F,  row.names = F)


}
