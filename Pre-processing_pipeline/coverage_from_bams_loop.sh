#!/bin/bash
#SBATCH --partition 128x24   
#SBATCH --job-name=bam_coverage # Job name
#SBATCH --time=24:00:00
#SBATCH --mem=120G
#SBATCH --output=bam_coverage_output.txt
#SBATCH --nodes=1

## load samtools
module load samtools/samtools-1.10

## change into the directory with .bams
cd /hb/scratch/jharenca/pop_gen/combinedP1P2/temp_dedup/AVH_only

# variable setting
BAM_LIST=$(ls *clean.bam) # make list of file names to iterate through

## get depth and breadth of coverage

for BAM_NAME in $BAM_LIST; do
# Get mean read depth - here 's' is cumulative depth at all sites and 'c' is the total # of positions
        echo " samtools depth -a ${BAM_NAME} | awk '{c++;s+=$3}END{print s/c}' "
        depth=$(samtools depth -a ${BAM_NAME} | awk '{c++;s+=$3}END{print s/c}') 
# Get Breadth of Coverage - here 'c' is the total # of positions again and total receives an increment of 1 when depth > 0
# bredth is then (total/c)*100 (percent of the genome covered at least once!)
        echo " samtools depth -a ${BAM_NAME} | awk '{c++; if($3>0) total+=1}END{print (total/c)*100}' "
        breadth=$(samtools depth -a ${BAM_NAME} | awk '{c++; if($3>0) total+=1}END{print (total/c)*100}')
        echo "${BAM_NAME}, $depth, $breadth" >> coverage_data.txt
done