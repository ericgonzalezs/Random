grep ">" Ha412HOv2.0-20181130.fasta | sed 's/>//g' | sed 's/len=//g' | sed 's/ \+/\t/g' > Ha412HOv2.0-20181130.bed  #create a bed with chromosome name and length

bedtools makewindows -g Ha412HOv2.0-20181130.bed -w 500 > genome_500x.bed

bedtools coverage -mean -a genome_500x.bed -b Ha412HOv2.ANN1372-3_aligned_default_s.bam -sorted > mean_coverage_per_window_default_pbmm2.txt
