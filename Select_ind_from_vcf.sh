#!/bin/bash
#SBATCH --account=def-rieseber
#SBATCH --time=1-5
#SBATCH --mem=8G
module load StdEnv/2020 vcftools/0.1.16 gcc/9.3.0 bcftools/1.11 samtools/1.12

tabix -p vcf file.vcf.gz
bcftools view -S IND.txt file.vcf.gz --force-samples -Oz > file_IND.vcf.gz
