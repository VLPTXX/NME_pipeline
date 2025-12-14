#!/bin/bash

FILTER_INPUT=""            # Input directory containing VCF files to be filtered
FILTER_OUTPUT=""           # Output directory for the filtered VCF files

cd $FILTER_INPUT

for file in $FILTER_INPUT*.vcf;
do echo $file;
   new_filename=$(basename ${file});
   new_filename2=${new_filename::-4};
   output_file=$FILTER_OUTPUT$new_filename2;

bcftools filter -i "QD >2" $file > $output_file.F1.vcf;
# bcftools filter -i "SOR <4" $file > $output_file.F2.vcf;              # Additional 'bcftools filter' parameters that can be applied:
# bcftools filter -i "FS <30" $file > $output_file.F3.vcf;
# bcftools filter -i "SOR <4" $output_file.F1.vcf > $output_file.F4.vcf;
# bcftools filter -i "FS <30" $output_file.F4.vcf > $output_file.F5.vcf;

done


