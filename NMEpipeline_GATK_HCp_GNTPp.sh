#!/bin/bash

INPUT_FOLDER=""                                             # Input folder with BAM files
HC_OUTPUT_FOLDER=""                                         # Output folder for Haplotypecaller output
GNTP_OUTPUT_FOLDER=""                                       # Output folder fo GenotypeGVCF output
GATK_BIN=""                                                 # Path to the main GATK executable script
FASTA_REF=""                                                # Path to fasta reference
EXOME_INTERVALS=""                                          # Path to BED file defining exome intervals

cd "$INPUT_FOLDER"

echo "Starting HaplotypeCaller on BAM files..."
parallel "$GATK_BIN --java-options \"-Xmx4g\" HaplotypeCaller \
    -R \"$FASTA_REF\" \
    -I {} \
    -O {}.g.vcf.gz \
    -L \"$EXOME_INTERVALS\" \
    -ERC BP_RESOLUTION \
    -ip 150 -OVI" \
::: *.bam

echo "Renaming and moving HaplotypeCaller outputs..."
# Loop for G.VCF.GZ files
for file in *.g.vcf.gz; do
    if [ -f "$file" ]; then
        base_name=$(basename "$file" .g.vcf.gz)
        new_prefix=${base_name%.bam}
        output_file="${HC_OUTPUT_FOLDER}${new_prefix}.hcoutput.g.vcf.gz"
        if [ -n "$new_prefix" ]; then
             mv "$file" "$output_file"
        fi
    fi
done

# Loop for .TBI Index files
for file in *.g.vcf.gz.tbi; do
    if [ -f "$file" ]; then
        base_name=$(basename "$file" .g.vcf.gz.tbi)
        new_prefix=${base_name%.bam}
        output_file="${HC_OUTPUT_FOLDER}${new_prefix}.hcoutput.g.vcf.gz.tbi"
        if [ -n "$new_prefix" ]; then
             mv "$file" "$output_file"
        fi
    fi
done

echo "Starting Genotyping..."
cd "$HC_OUTPUT_FOLDER"
parallel "$GATK_BIN --java-options \"-Xmx4g\" GenotypeGVCFs \
    -R \"$FASTA_REF\" \
    -V {} \
    -O {}.gntp.vcf.gz \
    -L \"$EXOME_INTERVALS\" \
    --include-non-variant-sites true" \
::: *.hcoutput.g.vcf.gz

echo "Renaming and moving GenotypeGVCFs outputs..."
# Loop for Final VCF (.vcf.gz) files
for file in *.gntp.vcf.gz; do
    if [ -f "$file" ]; then
        base_name=$(basename "$file" .gntp.vcf.gz) 
        new_prefix=${base_name%.hcoutput.g.vcf.gz}
        output_file="${GNTP_OUTPUT_FOLDER}${new_prefix}.gntp.vcf.gz"
        if [ -n "$new_prefix" ]; then
             mv "$file" "$output_file"
        fi
    fi
done

# Loop for .TBI Index files
for file in *.gntp.vcf.gz.tbi; do
    if [ -f "$file" ]; then
        base_name=$(basename "$file" .gntp.vcf.gz.tbi)
        new_prefix=${base_name%.hcoutput.g.vcf.gz}
        output_file="${GNTP_OUTPUT_FOLDER}${new_prefix}.gntp.vcf.gz.tbi"
        if [ -n "$new_prefix" ]; then
             mv "$file" "$output_file"
        fi
    fi
done

echo "Script processing complete."
