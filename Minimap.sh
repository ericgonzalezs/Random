#!/bin/bash
#SBATCH --account=def-rieseber
#SBATCH --time=3-0
#SBATCH --cpus-per-task=15
#SBATCH --mem=490G
module load StdEnv/2020 minimap2/2.24

minimap2 -t 15 -acx asm5 Ha412HOv2.0-20181130_17chr_newname.fasta Harg2202r1.0-20210824.genome.new_names.new_names.fasta > Ha412_Harg.sam

minimap2 -t 15 -acx asm5 Harg2202r1.0-20210824.genome.new_names.new_names.fasta Harg2202r1.0-20210824.genome.new_names.new_names.fasta >  Harg_Harg.sam

#maf to paf

module load StdEnv/2020 samtools/1.17

export PATH="/home/egonza02/scratch/SOFTWARE/minimap2/minimap2-2.26_x64-linux:$PATH"

paftools.js sam2paf <(samtools view -h Ha412_Harg2202_Jerome_contigs.bam) > Ha412_Harg2202_Jerome.paf
