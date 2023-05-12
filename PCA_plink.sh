#!/bin/bash
#SBATCH --account=def-rieseber
#SBATCH --time=2-10
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=10G
module load StdEnv/2020 plink/2.00-10252019-avx2

plink2 --vcf Annuus.ann_env.tranche90_snps_bi_AN50_AF99_MAF05_AN50_biallelic_DP5_12_NoTE_noMap_PASS.vcf.gz --double-id --allow-extra-chr --set-missing-var-ids @:# --make-bed --pca --out ALL_
PASS
