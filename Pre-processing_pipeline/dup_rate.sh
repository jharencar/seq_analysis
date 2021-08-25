#!/bin/bash
#SBATCH --partition 128x24 # this means each node (there are 19 nodes in this partition) has 128 GB RAM and 24 cores/cpus 
#SBATCH --job-name=dup_rate# Job name
#SBATCH --time=24:00:00 
#SBATCH --output=dup_rate_.%A_%a.out
#SBATCH -e dup_rate_.%A_%a.err
#SBATCH --mem=105G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --array=[1-156]%3  # []%3 limits it so only 3 run in parallel at once
#submit with SBATCH array, submit as normal or to specify certain array numbers: sbatch --array=x-y job_script.sbatch

# Code to remove duplicates with samtools markdups.
#by: Julia Harenčár, 210817

## load samtools
module load gatk/gatk-4.1.8.1

## change into the directory with .bams
cd /hb/scratch/jharenca/pop_gen/combinedP1P2/merged_bams

# set variables
BAM_FILE=$(ls *no_sml.bam | sed -n ${SLURM_ARRAY_TASK_ID}p) # make list of file names to iterate through
SAMPLE_ID=$(echo $BAM_FILE |cut  -d "_" -f 1,2)

# get original # of mapped reads and save to varibale for printing in summary file with new # mapped reads.
echo "gatk FlagStat -I ${BAM_FILE} | awk -F " " 'NR == 5 {print $1}'"
before=$(gatk FlagStat -I ${BAM_FILE} | awk -F " " 'NR == 5 {print $1}') # gives number of mapped reads b4 dedup

#re-get basic stats to compare mapped reads
echo "gatk FlagStat -I ${SAMPLE_ID}_clean.bam | awk -F " " 'NR == 5 {print $1}'"
after=$(gatk FlagStat -I ${SAMPLE_ID}_clean.bam | awk -F " " 'NR == 5 {print $1}')

#print before and after number mapped reads and calculated duplication rate to .csv
percent=$(echo "(1-$after/$before)*100" | bc -l)
echo "${SAMPLE_ID}, $before, $after, $percent" >> duplication_rate.csv

