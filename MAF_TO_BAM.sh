#!/bin/bash
#SBATCH --account=def-rieseber
#SBATCH --time=3-0
#SBATCH --mem=50G
#SBATCH --array=1-3
module load StdEnv/2020 samtools/1.17 python/2.7.18
i=$(ls *maf | head -n $SLURM_ARRAY_TASK_ID | tail -n 1)

name=$(echo $i | cut -d "." -f 1)

python2 /home/egonza02/scratch/SOFTWARE/ANCHORWAVE/anchorwave/scripts/maf-convert sam $i | sed 's/[0-9]\+H//g' > "$i"".sam"

cat  "$i"".sam" | samtools view -O BAM --reference Ha412HOv2_onlychr_NewName.fa - | samtools sort - > "$i"".bam"

samtools index "$i"".bam"
