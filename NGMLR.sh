#!/bin/bash
#SBATCH --account=rpp-rieseber
#SBATCH --time=5-10
#SBATCH --cpus-per-task=50
#SBATCH --mem=170G

ngmlr -t 50 -r Ha412HOv2.0-20181130.fasta -q Sequel.RunS142_S2.002.ANN1372-3.ccs.fasta -o Sequel.RunS142_S2.002.ANN1372-3_6.ccs.sam
samtools sort -@ 10 Sequel.RunS142_S2.002.ANN1372-3_5.ccs.sam > Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR.bam
samtools index Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR.bam

ngmlr -t 10 -r Ha412HOv2.0-20181130.fasta -q Sequel.RunS145_S2.002.ANN826-3.ccs.fasta -o Sequel.RunS142_S2.002.ANN826-3.ccs.sam
samtools sort -@ 10 Sequel.RunS142_S2.002.ANN826-3.ccs.sam > Sequel.RunS142_S2.002.ANN826-3.ccs_NGMLR.bam
samtools index  Sequel.RunS142_S2.002.ANN826-3.ccs_NGMLR.bam


##add Q
samtools view Sequel.RunS142_S2.002.ANN1372-3.ccs.bam | sort -k1,1 > Sequel.RunS142_S2.002.ANN1372-3.ccs_ordered_by_name.sam
samtools view Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR.bam | sort -k1,1 > Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR_ordered_by_name.sam

join -j 1 -o1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,1.10,2.11,1.12,1.13,1.14,1.15,1.16,1.17,1.18,1.19,1.20,1.21,1.22,1.23 Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR_ordered_by_name.sam Sequel.R
unS142_S2.002.ANN1372-3.ccs_ordered_by_name.sam | sed 's/ /\t/g' > Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR_withQ.bam

mv Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR_withQ.bam Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR_withQ.sam

sed 's/[\t][\t][\t]*$//' Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR_withQ.sam > Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR_withQ_no_tabs.sam

sed -i '${s/$/\t/}' Sequel.RunS142_S2.002.ANN1372-3_5.ccs_NGMLR_withQ_no_tabs.sam

#better using fastq files
#!/bin/bash
#SBATCH --account=rpp-rieseber
#SBATCH --time=6-10
#SBATCH --cpus-per-task=15
#SBATCH --mem=30G
module load nixpkgs/16.09  intel/2018.3 samtools/1.9

ngmlr -t 15 -r Ha412HOv2.0-20181130.fasta -q Sequel.RunS145_S2.002.ANN826-3.ccs.fastq -o Sequel.RunS14
2_S2.002.ANN826-3_t.ccs.sam
samtools sort -@ 15 Sequel.RunS142_S2.002.ANN826-3_t.ccs.sam > Sequel.RunS142_S2.002.ANN826-3.ccs_NGMLR_bq_t.bam
samtools index  Sequel.RunS142_S2.002.ANN826-3.ccs_NGMLR_bq_t.bam

ngmlr -t 15 -r Ha412HOv2.0-20181130.fasta -q Sequel.RunS142_S2.002.ANN1372-3.ccs.fastq -o Sequel.RunS1
42_S2.002.ANN1372-3_t.ccs.sam
samtools sort -@ 15 Sequel.RunS142_S2.002.ANN1372-3_t.ccs.sam > Sequel.RunS142_S2.002.ANN1372-3.ccs_NGMLR_bq_t.bam
samtools index  Sequel.RunS142_S2.002.ANN1372-3.ccs_NGMLR_bq_t.bam
