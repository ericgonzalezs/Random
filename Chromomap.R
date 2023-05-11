library(chromoMap)
jpeg("LD_per_chr.jpg", width=4000, height= 6000)
chromoMap("chromosome_file.txt","anno.txt", data_based_color_map = T, data_type = "numeric")
dev.off()

#chromosome_file.txt 3 coulm file that looks like this:
#Ha412HOChr01    1       159217232
#Ha412HOChr02    1       184765313
#Ha412HOChr03    1       182121094
#Ha412HOChr04    1       221926752
#Ha412HOChr05    1       187413619

#anno.txt:
#Ha412HOChr01-1076-1114  Ha412HOChr01    1076    1114    0.172502
#Ha412HOChr01-1076-1128  Ha412HOChr01    1076    1128    0.23064
#Ha412HOChr01-1076-1202  Ha412HOChr01    1076    1202    0.0223532
#Ha412HOChr01-1114-1128  Ha412HOChr01    1114    1128    0.1328
#Ha412HOChr01-1114-1202  Ha412HOChr01    1114    1202    0.00455928

