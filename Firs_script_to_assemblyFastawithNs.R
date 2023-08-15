library(tidyverse)
library(tidysq)
library(data.table)
args = commandArgs(trailingOnly = TRUE)

MIX_ASSEM <- args[1]
PREFIX <- args[2]
MIX_FASTA <- args[3]
SAVE_DIR <- args[4]

HAP12_assembly <- read.table(MIX_ASSEM, fill = TRUE, col.names = paste("V", 1:200, sep = ""))
read_fasta(MIX_FASTA, alphabet = "dna_ext") -> HAP12_FASTA


HAP12_assembly %>%
  filter(!grepl("^>",V1)) %>%
  mutate(CHR = row_number()) %>%
  gather(contig_order_in_chr, order_sign, V1:V200) %>% #cambie V1 a V200
  filter(!is.na(order_sign)) %>%
  mutate(contig_order_in_chr=as.numeric(gsub("V","",contig_order_in_chr))) %>%
  mutate(order = abs(as.numeric(order_sign))) %>%
  arrange(CHR,
          contig_order_in_chr)  %>%
  full_join(.,
            select(filter(HAP12_assembly,grepl("^>",V1)),fragment_ID = V1,original_order = V2),
            by=c("order"="original_order")) %>%
  mutate(fragment_ID = gsub(">","",fragment_ID)) %>%
  mutate(HAP = ifelse(grepl("h1",fragment_ID),"H1","H2")) -> mid_data


mid_data %>%
  group_by(CHR,HAP) %>%
  tally() %>%
  ungroup() %>%
  group_by(CHR) %>%
  filter(n==max(n)) %>%
  ungroup() %>%
  select(CHR,HAP_new = HAP) -> CHRHAP

mid_data %>%
  full_join(.,
            CHRHAP) %>%
  group_by(HAP_new) %>%
    arrange(HAP_new,CHR) %>%
    mutate(NEW_CHR = as.integer(factor(CHR))) %>%
  ungroup() %>%
  mutate(Chromosome = paste(HAP_new,"HiC_scaffold",NEW_CHR,sep = "_")) %>%
  mutate(orientation = ifelse(order_sign<0,"R","F")) %>%
  select(Chromosome,
         contig_order_in_chr,
         fragment_ID,
         orientation) -> CONTIG_ORDER_CHR

HAP12_FASTA %>%  #pero lo había borrado antes,por eso no salía
  full_join(.,
            CONTIG_ORDER_CHR,by=c("name" = "fragment_ID")) -> REV_FOR_CONTIG


REV_FOR_CONTIG %>%
  filter(orientation == "R") %>%
  select(-orientation) -> REV_CONTIG


REV_FOR_CONTIG %>%
  filter(orientation == "F") %>%
  select(-orientation) -> FOR_CONTIG


REV_CONTIG %>% mutate(sq = reverse(complement(sq))) -> REV_COMP_CONTIGS


bind_rows(FOR_CONTIG,
          REV_COMP_CONTIGS) -> CORRECTED_CONTIGS


CORRECTED_CONTIGS %>%
  distinct(Chromosome) %>%
  pull(Chromosome) -> CHROMOSOME

NS <- strrep("N", 500)

FINAL_FASTA <- NULL
for (CHR in 1:length(CHROMOSOME)) { CORRECTED_CONTIGS %>% filter(Chromosome == as.character(CHROMOSOME[CHR])) %>%  arrange(contig_order_in_chr) %>% pull(sq) %>% paste(  . ,sq(c(rep(NS,  leng
th(.) - 1), ""), "dna_ext"))  %>%  collapse() %>% enframe() %>% mutate(name = as.character(CHROMOSOME[CHR]))  %>% select(sq = value,  name) %>% bind_rows(., FINAL_FASTA) -> FINAL_FASTA }


write_fasta(pull(filter(FINAL_FASTA,grepl("^H1",name)),sq),pull(filter(FINAL_FASTA,grepl("^H1",name)),name),paste0(SAVE_DIR,"/",PREFIX,"_hap1.reviewed.chr_assembled.fasta"))

write_fasta(pull(filter(FINAL_FASTA,grepl("^H2",name)),sq),pull(filter(FINAL_FASTA,grepl("^H2",name)),name),paste0(SAVE_DIR,"/",PREFIX,"_hap2.reviewed.chr_assembled.fasta"))
