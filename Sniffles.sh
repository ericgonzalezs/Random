#!/bin/bash
#SBATCH --account=rpp-rieseber
#SBATCH --time=2-10
#SBATCH --cpus-per-task=3
#SBATCH --mem-per-cpu=10G
module load StdEnv/2020 sniffles/1.0.12b

#sniffles -m Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR.bam -v ANN1372-3_NGMLR_siniffles_ssensitive.vcf -s 2 -d 100000

sniffles -m Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR.bam -v ANN1372-3_NGMLR_siniffles_ssensitive_s2.vcf -s 2
