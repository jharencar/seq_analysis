#!/bin/bash
#SBATCH --partition 128x24 # this means each node (there are 19 nodes in this partition) has 128 GB RAM and 24 cores/cpus 
#SBATCH --job-name=rm_dups# Job name
#SBATCH --time=24:00:00 
#SBATCH --output=rm_dups_.%A_%a.out
#SBATCH -e rm_dups_.%A_%a.err
#SBATCH --mem=105G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --array=[1-156]%3  # []%3 limits it so only 3 run in parallel at once
#submit with SBATCH array, submit as normal or to specify certain array numbers: sbatch --array=x-y job_script.sbatch

# Code to remove duplicates with samtools markdups.
#by: Julia Harenčár, 210817

## load samtools
module load samtools/samtools-1.10 gatk/gatk-4.1.8.1

## change into the directory with .bams
cd /hb/scratch/jharenca/pop_gen/combinedP1P2/merged_bams

# set variables
BAM_FILE=$(ls *no_sml.bam | sed -n ${SLURM_ARRAY_TASK_ID}p) # make list of file names to iterate through
SAMPLE_ID=$(echo $BAM_FILE |cut  -d "_" -f 1,2)

### removing duplicates ###
# to use markdup, need several steps first:

#name order/collate
echo "samtools sort -n -o ${SAMPLE_ID}_Nsorted.bam ${BAM_FILE}"
samtools sort -n -o ${SAMPLE_ID}_Nsorted.bam ${BAM_FILE}

#Add ms and MC tags for markdup to use later (-m adds ms (mate score) tags):
echo "samtools fixmate -m ${SAMPLE_ID}_Nsorted.bam ${SAMPLE_ID}_fixmated.bam"
samtools fixmate -m ${SAMPLE_ID}_Nsorted.bam ${SAMPLE_ID}_fixmated.bam

#Markdup needs position order (-o is output file)
echo "samtools sort -o ${SAMPLE_ID}_sorted.bam ${SAMPLE_ID}_fixmated.bam"
samtools sort -o ${SAMPLE_ID}_sorted.bam ${SAMPLE_ID}_fixmated.bam

#finally, mark and remove duplicates 
# https://www.htslib.org/doc/samtools-markdup.html
# -l INT : Expected maximum read length of INT bases. [300]
# -r : Remove duplicate reads.
# -s : Print some basic stats. See STATISTICS.
# -f file : Write stats to named file.
# -u Output uncompressed SAM, BAM or CRAM.

echo "samtools markdup -r ${SAMPLE_ID}_sorted.bam ${SAMPLE_ID}_clean.bam"
samtools markdup -r ${SAMPLE_ID}_sorted.bam ${SAMPLE_ID}_clean.bam

#remove all the annoying intermadiate bams
echo "rm ${SAMPLE_ID}_Nsorted.bam ${SAMPLE_ID}_sorted.bam ${SAMPLE_ID}_fixmated.bam"
rm ${SAMPLE_ID}_Nsorted.bam ${SAMPLE_ID}_sorted.bam ${SAMPLE_ID}_fixmated.bam


# For 19.466_VILL: (5210 total mapped reads after dedup, 56560 before) DANGGGGG... thats 90% duplicates! WAY lower... I guess my library complexity was trash... D': 
# also way fewer "propperly paired"... why did that happen? 

#for 19.606_ALLE_q20.bam : before rmdups - 4705457; after rmdups - 4083493
