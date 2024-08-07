#!/bin/bash

# Создаем директорию для хранения геномных файлов
mkdir -p ~/genomes
cd ~/genomes
# Скачиваем геном версии 2.1 и 4.0
rsync -L -a -P \
  rsync://ftp.ncbi.nlm.nih.gov/genomes/genbank/plant/Glycine_max/all_assembly_versions/GCA_000004515.4_Glycine_max_v2.1/GCA_000004515.4_Glycine_max_v2.1_genomic.fna.gz ./
rsync -L -a -P \
  rsync://ftp.ncbi.nlm.nih.gov/genomes/refseq/plant/Glycine_max/all_assembly_versions/GCF_000004515.6_Glycine_max_v4.0/GCF_000004515.6_Glycine_max_v4.0_genomic.fna.gz ./
# Разархивируем геном
gunzip GCA_000004515.4_Glycine_max_v2.1_genomic.fna.gz
gunzip GCF_000004515.6_Glycine_max_v4.0_genomic.fna.gz
# Скачиваем VCF файл
wget -O input.vcf https://drive.google.com/file/d/1oDEidhUsECqFLO5F2RjJCJP-oEG9oQ6h/view?usp=drive_link 
