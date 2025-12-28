# NME Finder Data Preprocessing

Files in this repository are provided for data preprocessing used by the NME Finder web application: https://nmefi.lf2.cuni.cz/

**Prerequisites and Setup**

Ensure all necessary file paths are correctly set in both script files.
We recommend extending exome boundaries in the BED files (we used a 50 bp extension in our analysis).

**Pipeline Steps**

1.  **VCF Generation:**
    `NMEpipeline_GATK_HCp_GNTPp.sh` processes BAM files into final VCF.GZ files.

2.  **Trio Merging:**
    You must merge the final VCF.GZ files into trios using the order: **father-mother-child** to generate merged VCF files. The `bcftools merge` command can be used for this step.

3.  **Final Filtering:**
    Subsequently, run `NMEpipeline_Filter.sh` to filter the merged files, which are then ready for use as NME Finder inputs.

More details can be found in the NME Finder manual.
