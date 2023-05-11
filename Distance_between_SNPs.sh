#!/bin/bash
#SBATCH --account=def-rieseber
#SBATCH --time=1-1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G

for i in $(cut -f 1 Chr_lenght.txt) #taking the chromosome name
do
zcat file.vcf.gz | grep -v "#" | grep -w $i | awk 'NR==1{s=$2;next}{print s, $2, $2-s;s=$2}' > "$i"_SNP_distnce.txt
done
