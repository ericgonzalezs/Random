#determine wich genomes to flip according to their alignments with Ha412
library(dplyr)
library(tidyr)
HAP1 <- read.table("VIGUIERA_hap1.reviewed_vs_Ha412_anchorwave_tab_fp.txt")
colnames(HAP1) <- c("rs", "re", "qs", "qe", "error", "qid", "rid", "strand")
HAP1$len_Ha412 <- HAP1$re - HAP1$rs
HAP1$len_OG <- HAP1$qe - HAP1$qs
Len <- read.table("VIGUIERA_hap1.reviewed.chr_assembled.fasta.fai")
Len <- Len[c(1,2)]
tabla <- HAP1 %>%   left_join(Len, by = c("qid" = "V1"))
colnames(tabla) <- c("rs", "re", "qs", "qe", "error", "qid", "rid", "strand", "len_Ha412", "len_OG", "V2")
strand_tabla <- tabla %>% group_by(qid, strand) %>% summarize(total_lenght = sum(len_OG/V2)) %>%  arrange(qid, desc(total_lenght))
tabla_final_H1 <- strand_tabla %>% group_by(qid) %>% filter(total_lenght == max(total_lenght)) %>% mutate(orientation = ifelse(strand == "-", "R", "F"))
save.image("chr_to_flipH1.RData")

#Flip the chromosomes and write fasta
library(tidyverse)
library(tidysq)
library(data.table)
FASTA_H1 <- read_fasta("VIGUIERA_hap1.reviewed.chr_assembled.fasta", alphabet = "dna_ext")
load("chr_to_flipH1.RData")

HAP1_JOINED <- FASTA_H1 %>% full_join(tabla_final_H1, by = c("name" = "qid"))
HAP1_JOINED_R  <- HAP1_JOINED %>%  filter(orientation == "R") %>%  select(sq, name)

HAP1_JOINED_Rests <- HAP1_JOINED %>%  filter(orientation != "R"  | is.na(orientation)) %>%  select(sq, name)
HAP1_JOINED_Reversed <- HAP1_JOINED_R %>% mutate(sq = reverse(complement(sq)))

ALMOSTFINAL <- bind_rows(HAP1_JOINED_Reversed, HAP1_JOINED_Rests)
ALMOSTFINAL %>%  mutate(length = get_sq_lengths(sq)) %>% arrange(desc(length)) %>% select(-length)-> FINAL_FASTA

write_fasta(FINAL_FASTA$sq, FINAL_FASTA$name, "VIGUIERA_hap1.reviewed.chr_assembled.orientationcorrected.fasta")

