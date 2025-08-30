#!/bin/bash

# spojeny skript pre HC a GNTP


input_folder="/media/vlado/vol2/GData/GATK_pipeline/BAM/"
output_folder="/media/vlado/vol2/GData/GATK_pipeline/HC_output/"

cd $input_folder
parallel '/home/vlado/gatk-4.6.0.0/gatk --java-options "-Xmx4g" HaplotypeCaller \
    -R /media/vlado/vol2/GData/GATK_pipeline/ref/HG19uscs.fasta \
    -I {} \
    -O {}.g.vcf.gz \
    -L /media/vlado/vol2/GData/GATK_pipeline/ref/Twist_Exome_Targets_hg19_ext50.bed \
    -ERC BP_RESOLUTION \
    -ip 150 -OVI' \
::: *.bam


#     -L /media/vlado/vol2/GData/GATK_pipeline/ref/MedExome_modext50.bed \


for file in $input_folder*.g.vcf.gz;
do new_filename=$(basename ${file});
   new_filename2=${new_filename::-35};
   output_file=$output_folder$new_filename2.hcoutput.g.vcf.gz;
   echo $output_file
   mv $file $output_file
done

for file in $input_folder*.g.vcf.gz.tbi;
do new_filename=$(basename ${file});
   new_filename2=${new_filename::-39};
   output_file=$output_folder$new_filename2.hcoutput.g.vcf.gz.tbi;
   echo $output_file
   mv $file $output_file
done


input_folder="/media/vlado/vol2/GData/GATK_pipeline/HC_output/"
output_folder="/media/vlado/vol2/GData/GATK_pipeline/genotype_GVCF_output/"

cd $input_folder
parallel -j 4 '/home/vlado/gatk-4.6.0.0/gatk --java-options "-Xmx4g" GenotypeGVCFs \
    -R /media/vlado/vol2/GData/GATK_pipeline/ref/HG19uscs.fasta \
    -V {} \
    -O {}.gntp.vcf.gz \
    -L /media/vlado/vol2/GData/GATK_pipeline/ref/Twist_Exome_Targets_hg19_ext50.bed \
    --include-non-variant-sites true' \
::: *.vcf.gz

   
for file in $input_folder*.gntp.vcf.gz;
do new_filename=$(basename ${file});
   new_filename2=${new_filename::-30};
   output_file=$output_folder$new_filename2.gntp.vcf.gz;
   echo $output_file
   mv $file $output_file
done

for file in $input_folder*.gntp.vcf.gz.tbi;
do new_filename=$(basename ${file});
   new_filename2=${new_filename::-34};
  output_file=$output_folder$new_filename2.gntp.vcf.gz.tbi;
   echo $output_file
   mv $file $output_file
done

