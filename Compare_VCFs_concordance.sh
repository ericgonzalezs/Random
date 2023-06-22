tabix -p vcf ANN1372-3_ANN826-3_Biallelic_SNPs_QD2_CHR_scaffolds_all.vcf.gz

bcftools query -l ANN1372-3_ANN826-3_Biallelic_SNPs_QD2_CHR_scaffolds_all.vcf.gz > sample_list2.txt

for i in $(cat sample_list2.txt); do bcftools gtcheck -G 1 -s $i -g Annuus.ann_env.tranche90_snps_bi_AN50_AF99.vcf.gz ANN1372-3_ANN826-3_Biallelic_SNPs_QD2_CHR_scaffolds_all.vcf.gz | grep -v
 "#" > "$i""_compare.txt" & done ; wait
