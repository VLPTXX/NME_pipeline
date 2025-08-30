#!/bin/bash

# Filtrovanie vcf suborov, vsetkych vo vstupnom adresari, podla vybranych QC parametrov, vystup do output adresaru
# filtre podla koncovky suboru F1 = QD >2, F2 = SOR <4, F3 = FS <30, F4 = QD >2 + SOR <4, F5 = QD >2 + SOR <4 + FS <30

filter_input="/media/vlado/vol2/GData/GATK_pipeline/genotype_GVCF_output/"
filter_output="/media/vlado/vol2/GData/GATK_pipeline/Filter/"


cd $filter_input

for file in $filter_input*.vcf;
do echo $file;
   new_filename=$(basename ${file});
   new_filename2=${new_filename::-4};
   output_file=$filter_output$new_filename2;

bcftools filter -i "QD >2" $file > $output_file.F1.vcf;
bcftools filter -i "SOR <4" $file > $output_file.F2.vcf;
bcftools filter -i "FS <30" $file > $output_file.F3.vcf;
bcftools filter -i "SOR <4" $output_file.F1.vcf > $output_file.F4.vcf;
bcftools filter -i "FS <30" $output_file.F4.vcf > $output_file.F5.vcf;

done


