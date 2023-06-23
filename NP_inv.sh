#!/bin/bash
#SBATCH --account=rpp-rieseber
#SBATCH --time=3-10
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=10G
module load StdEnv/2020 java/13.0.2

java -jar  /home/egonza02/projects/rpp-rieseber/egonza02/bin/software/npInv/npInv1.28.jar --input Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR.bam --output Ann1372_standard.vcf
