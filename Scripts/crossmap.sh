# Выполнение CrossMap для преобразования координат в VCF файле
# Путь к файлу цепей (chain file)
chain_file="final.chain"
# Входной VCF файл с координатами в сборке 2.1
input_vcf_file="input.vcf"
# Последовательности хромосом целевой сборки (4.0) в формате FASTA
ref_genome_fasta="GCF_000004515.6_Glycine_max_v4.0_genomic.fna"
# Выходной VCF файл с координатами в сборке 4.0
output_vcf_file="output.vcf"
# Выполнение CrossMap для преобразования координат
CrossMap.py vcf $chain_file $input_vcf_file $ref_genome_fasta $output_vcf_file
