samtools calmd Ha412HOv2.ANN1372-3_aligned_default_s.bam Ha412HOv2.0-20181130.fasta | samtools view -b - | /home/egonza02/projects/rpp-rieseber/egonza02/PacBio_HiFi_8x/software/BIOCONDA/mini
conda3/bin/htsbox samview -p - | awk '{x+=$10;y+=$11}END{print (x/y)*100}'  > percentage_of_identiyt_0MQ.txt
