#!/bin/bash
#SBATCH --account=def-rieseber
#SBATCH --time=1-5
#SBATCH --mem=8G
module load StdEnv/2020 vcftools/0.1.16

vcftools --gzvcf File.vcf.gz --hap-r2 --ld-window-bp 1000 --out ld_SNPs_1kb
