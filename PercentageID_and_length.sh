#id% and alignment length

for ((i=30; i<=60; i+=30)); do samtools calmd Ha412HOv2.ANN1372-3_aligned_noidentityfilter_s.bam Ha412HOv2.0-20181130.fasta | samtools view -bq $i - | /home/egonza02/projects/rpp-rieseber/eg
onza02/PacBio_HiFi_8x/software/BIOCONDA/miniconda3/bin/htsbox samview -p - | awk '{x+=$10;y+=$11}END{print (x/y)*100}'  > "percentage_of_identiyt_""$i"MQ".txt" & done ; wait

for ((i=30; i<=60; i+=30)); do samtools calmd Ha412HOv2.ANN1372-3_aligned_noidentityfilter_s.bam Ha412HOv2.0-20181130.fasta | samtools view -bq $i - | /home/egonza02/projects/rpp-rieseber/eg
onza02/PacBio_HiFi_8x/software/BIOCONDA/miniconda3/bin/htsbox samview -p - | awk '{print ($10/$11)*100}'  > "percentage_of_identiyt_all""$i"MQ".txt" & done ; wait

for ((i=30; i<=60; i+=30)); do samtools calmd Ha412HOv2.ANN1372-3_aligned_noidentityfilter_s.bam Ha412HOv2.0-20181130.fasta | samtools view -bq $i- | /home/egonza02/projects/rpp-rieseber/ego
nza02/PacBio_HiFi_8x/software/BIOCONDA/miniconda3/bin/htsbox samview -p - | awk '{print $11}'  > "length""$i"MQ".txt"& done ; wait
