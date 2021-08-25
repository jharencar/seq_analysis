#!/bin/bash
#SBATCH --partition 128x24   
#SBATCH --job-name=bam_merge # Job name
#SBATCH --time=24:00:00
#SBATCH --output=bam_merge_output.txt
#SBATCH --mail-type=END, FAIL              # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jharenca@ucsc.edu  # Where to send mail

## load samtools
module load samtools/samtools-1.10

## change into the directory with .bams
cd /hb/scratch/jharenca/vill_alle_plate1/newdata/AVH_plate2/mapped

# variable setting
SAMPLE_LIST=$(ls *F_unpaired_output.bam | cut -d "_" -f 1,2)  # pipes filenames to cut to isolate the sample names and assigns a list of sample names to the variable. 

## merge bams with samtools merge

for SAMPLE_NAME in $SAMPLE_LIST; do
        echo " samtools merge -r ${SAMPLE_NAME}_merged.bam ${SAMPLE_NAME}_output.bam ${SAMPLE_NAME}_F_unpaired_output.bam ${SAMPLE_NAME}_R_unpaired_output.bam "
        samtools merge -r ${SAMPLE_NAME}_merged.bam ${SAMPLE_NAME}_output.bam ${SAMPLE_NAME}_F_unpaired_output.bam ${SAMPLE_NAME}_R_unpaired_output.bam
done


### as an array instead of a list:
#SAMPLE_ARRAY=( $(ls *F_unpaired_output.bam | cut -d "_" -f 1,2) )  # pipes filenames to cut to isolate the sample names and assigns a list of sample names to the variable. 

## merge bams with samtools merge

#for SAMPLE_NAME in ${SAMPLE_ARRAY[@]}; do
#       echo ${SAMPLE_NAME}
#done
