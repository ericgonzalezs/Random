#!/bin/bash
#usage ./Calculate_het_per_inv.sh <vcf file> <positions file>

for arg in ${@}
do


while IFS= read -r i; do name=$(echo $i | sed 's/ /-/g')  ; echo $i | awk -v OFS='\t'  '{print $1, $2, $3}' |  bedtools intersect -a $1 -b - -sorted -g Ha412HOv2.0-20181130.bed | bgzip -c >
"$name"".vcf.gz"  ; done < $2

zcat $1 | grep "#" > Header.txt

while IFS= read -r i; do name=$(echo $i | sed 's/ /-/g')  ; cat Header.txt <(zcat "$name"".vcf.gz") | bgzip -c > "$name""_WH.vcf.gz"; done < $2


while IFS= read -r i; do name=$(echo $i | sed 's/ /-/g')  ; name2=$(echo $1 | cut -d "_" -f 1,2,3);   plink2 --vcf "$name""_WH.vcf.gz" --double-id --allow-extra-chr --set-missing-var-ids @:#
 \
--make-bed --pca --out "$name""_pca_""$name2"; done < $2


done
