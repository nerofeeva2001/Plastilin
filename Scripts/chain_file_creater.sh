# Создаем файлы с перечислением всех последовательностей
faToTwoBit ../genomes/GCA_000004515.4_Glycine_max_v2.1_genomic.fna GCA_000004515.4_Glycine_max_v2.1_genomic.2bit
faToTwoBit ../genomes/GCF_000004515.6_Glycine_max_v4.0_genomic.fna GCF_000004515.6_Glycine_max_v4.0_genomic.2bit
# Создаем файлы chrom.sizes
twoBitInfo GCA_000004515.4_Glycine_max_v2.1_genomic.2bit GCA_000004515.4_Glycine_max_v2.1.chrom.sizes
twoBitInfo GCF_000004515.6_Glycine_max_v4.0_genomic.2bit GCF_000004515.6_Glycine_max_v4.0.chrom.sizes

# Вычисление параметра repMatch пропорционально размеру генома
# 978491270 bases (23113809 N's 955377461 real 521707636 upper 433669825 lower) in 1190 sequences in 1 files
# Пропорциональное вычисление repMatch
calc \( 955377461 / 2861349177 \) \* 1024
# ( 955377461 / 2861349177 ) * 1024 ≈ 341.901377
# Округление:repMatch = 300

# Создаем ooc файл
blat_executable /root/genomes/GCF_000004515.6_Glycine_max_v4.0_genomic.fna /dev/null /dev/null -tileSize=11 -makeOoc=11.ooc -repMatch=300

# Создаем Chain файл (вместо обработки всего генома за один раз, разбиваю геномные последовательности на меньшие части и выполняю BLAT по частям, так как у меня не хватает ресурсов)
conda install -c bioconda seqkit
seqkit split -p 10 /root/genomes/GCA_000004515.4_Glycine_max_v2.1_genomic.fna
for part in GCA_000004515.4_Glycine_max_v2.1_genomic.fna.split/*.fna; do
    blat_executable \
        -ooc=11.ooc \
        -tileSize=11 \
        -repMatch=300 \
        -minScore=30 \
        -minIdentity=90 \
        $part \
        /root/genomes/GCF_000004515.6_Glycine_max_v4.0_genomic.fna \
        output_${part##*/}.psl
done
cat output_*.psl > combined_output.psl

# Создаем chain файл
axtChain -psl -verbose=0 \
    -linearGap=medium \
    combined_output.psl \
    /root/genomes/GCA_000004515.4_Glycine_max_v2.1_genomic.2bit \
    /root/genomes/GCF_000004515.6_Glycine_max_v4.0_genomic.2bit \
    output.chain
# Сортируем и упорядочиваем цепи
chainSort output.chain sorted.chain
# Подготавливаем цепи для сети (net) путем удаления лишних перекрытий и преобразования отсортированных цепей.
chainPreNet sorted.chain \
    /root/genomes/GCA_000004515.4_Glycine_max_v2.1.chrom.sizes \
    /root/genomes/GCF_000004515.6_Glycine_max_v4.0.chrom.sizes \
    preNet.chain
# Cоздаеv сеть из цепей, организуя их в структуру иерархических сетей (net). Сеть помогает определить наиболее подходящие выравнивания и избежать конфликтов. 
chainNet preNet.chain \
    /root/genomes/GCA_000004515.4_Glycine_max_v2.1.chrom.sizes \
    /root/genomes/GCF_000004515.6_Glycine_max_v4.0.chrom.sizes \
    net1 /dev/null
# Создаем финальный файл цепей.
netChainSubset net1 preNet.chain final.chain
