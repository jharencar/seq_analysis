#!/bin/bash
#SBATCH --partition 128x24 # this means each node (there are 19 nodes in this partition) has 128 GB RAM and 24 cores/cpus 
#SBATCH --job-name=bam_filter_q20# Job name
#SBATCH --time=24:00:00 
#SBATCH --output=bam_filter_q20_.%A_%a.out
#SBATCH -e bam_filter_q20_.%A_%a.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --array=[1-156]%3  # []%3 limits it so only 3 run in parallel at once
#submit with SBATCH array, submit as normal or to specify certain array numbers: sbatch --array=x-y job_script.sbatch

## load samtools
module load samtools/samtools-1.10

## change into the directory with .bams
cd /hb/scratch/jharenca/pop_gen/combinedP1P2/merged_bams

# variable setting
BAM_FILE=$(ls *merged.bam | sed -n ${SLURM_ARRAY_TASK_ID}p) # make list of file names to iterate through

# indexing/sorting bams
echo " samtools index ${BAM_FILE}"
samtools index ${BAM_FILE}

# EG: name pulls 19.572 and SPP pulls LAEV from: 19.572_LAEV_merged.bam
SAMPLE_ID=$(echo $BAM_FILE |cut  -d "_" -f 1,2)

# Filter bams to remove reads with phred score less than 20
echo " samtools view -q 20 ${BAM_FILE} > ${SAMPLE_ID}_q20.bam "
samtools view -q 20 -b ${BAM_FILE} > ${SAMPLE_ID}_q20.bam
