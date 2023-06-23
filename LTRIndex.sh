#SBATCH --account=rpp-rieseber
#SBATCH --time=5-5
#SBATCH --mem=100G
#SBATCH --cpus-per-task=10
module load StdEnv/2020 gcc/9.3.0 perl/5.30.2

export PATH=/home/egonza02/projects/rpp-rieseber/egonza02/bin/software/LTR_retriever/LTRharvest/gt-1.6.2-Linux_x86_64-64bit-complete/bin/:$PATH
export PATH=/home/egonza02/projects/rpp-rieseber/egonza02/bin/software/LTR_retriever/LTR_FINDER_parallel/LTR_FINDER_parallel:$PATH

gt suffixerator -db ARG.fasta -indexname ARG.fasta -tis -suf -lcp -des -ssp -sds -dna
gt ltrharvest -index ARG.fasta -minlenltr 100 -maxlenltr 7000 -mintsd 4 -maxtsd 6 -motif TGCA -motifmis 1 -similar 85 -vic 10 -seed 20 -seqids yes > ARG.fa.harvest.scn
LTR_FINDER_parallel -seq ARG.fasta -threads 10 -harvest_out -size 1000000 -time 300
cat ARG.fa.harvest.scn ARG.fasta.finder.combine.scn > ARG.fa.rawLTR.scn

#change names
sed -i 's/Harg2202//g' ARG.fa

sed -i '/^>/ s/ .*//' ARG.fa

module load StdEnv/2020 gcc/9.3.0 perl/5.30.2

conda activate LTR_retriever

cat ARG.fa.harvest.scn ARG.fa.finder.combine.scn > ARG.fa.rawLTR.scn

export PATH=/home/egonza02/projects/rpp-rieseber/egonza02/bin/software/LTR_retriever/LTR_retriever/:$PATH

LTR_retriever -genome ARG.fa -inharvest ARG.fa.rawLTR.scn -threads 31

#LAI -genome ARG.fa -intact genome.fa.pass.list -all genome.fa.out
conda deactivate
