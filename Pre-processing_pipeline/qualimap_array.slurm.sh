#!/bin/bash
#SBATCH --partition 128x24 # this means each node (there are 19 nodes in this partition) has 128 GB RAM and 24 cores/cpus 
#SBATCH --job-name=qualimap_q20# Job name
#SBATCH --time=24:00:00 
#SBATCH --output=qualimap_q20_.%A_%a.out
#SBATCH -e bam_filter_q20_.%A_%a.err
#SBATCH --mem=105G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --array=[1-156]%3  # []%3 limits it so only 3 run in parallel at once
#submit with SBATCH array, submit as normal or to specify certain array numbers: sbatch --array=x-y job_script.sbatch

# Load conda env to access qualimap
module load miniconda3.9
source activate JGH-conda-env

# set variables
BAM_FILE=$(ls *q20.bam | sed -n ${SLURM_ARRAY_TASK_ID}p) # make list of file names to iterate through
SAMPLE_ID=$(echo $BAM_FILE |cut  -d "_" -f 1,2)

# run qualimap
qualimap bamqc -bam /hb/scratch/jharenca/pop_gen/combinedP1P2/merged_bams/${BAM_FILE} \
-outdir /hb/home/jharenca/pop_gen/qualimap --java-mem-size=100G \
-outfile ${SAMPLE_ID}_qualimap.pdf -outformat PDF

#-sd means don't count duplicates when computing coverage
#-sdmode 0 means when skipping duplicates, only skip reads flagged as duplicates
#-os means calculate stats for regions outside the feature file (I gave it a bed file "new.bed" containing coordinates of coding exons. It will then report coverage statistics for both inside and outside of coding regions)
#--java-mem-size=4500M I think I had issues of it running too slowly. You can speed it up by specifying the amount of memory available. For this script, I specified 50GB of memory in my hummingbird bash script, so I specified 45000M (50GB) for bamqc to run (I think you're supposed to do a little less than the total amount you have available).