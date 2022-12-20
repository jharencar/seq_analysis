#!/bin/bash
#SBATCH --partition 128x24   
#SBATCH --job-name=bam_merge # Job name
#SBATCH --time=24:00:00
#SBATCH --output=bam_merge_.%A_%a.out
#SBATCH -e bam_merge_.%A_%a.err
#SBATCH --mail-type=END, FAIL              # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jharenca@ucsc.edu  # Where to send mail
#SBATCH --array=1-13 

## load samtools
module load samtools/samtools-1.10

## change into the directory with .bams
cd /hb/scratch/jharenca/pop_gen/new_mapping/Davis_plate1

# variable setting
# SAMPLE_LIST=$(ls *F_unpaired_output.bam | cut -d "_" -f 1,2)  # pipes filenames to cut to isolate the sample names and assigns a list of sample names to the variable. 

## merge bams with samtools merge

#for SAMPLE_NAME in $SAMPLE_LIST; do
#        echo " samtools merge -r ${SAMPLE_NAME}_merged.bam ${SAMPLE_NAME}_output.bam ${SAMPLE_NAME}_F_unpaired_output.bam ${SAMPLE_NAME}_R_unpaired_output.bam "
#        samtools merge -r ${SAMPLE_NAME}_merged.bam ${SAMPLE_NAME}_output.bam ${SAMPLE_NAME}_F_unpaired_output.bam ${SAMPLE_NAME}_R_unpaired_output.bam
#done


### as an array instead of a loop:
#!/bin/bash
#SBATCH --partition 128x24   
#SBATCH --job-name=bam_merge # Job name
#SBATCH --time=00:10:00
#SBATCH --output=bam_merge_output.txt
#SBATCH --mail-type=ALL              # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jharenca@ucsc.edu  # Where to send mail
#SBATCH -e bam_merge.err
#SBATCH --output=bam_merge_output.txt
#SBATCH --array=1-13

## load samtools
module load samtools/samtools-1.10

## change into the directory with .bams
cd /hb/scratch/jharenca/pop_gen/new_mapping/OG_plate2

# variable setting
F_UNPAIRED=$(ls *F_unpaired_output.bam | sed -n ${SLURM_ARRAY_TASK_ID}p) # make list of file names to iterate through
R_UNPAIRED=$(ls *R_unpaired_output.bam | sed -n ${SLURM_ARRAY_TASK_ID}p) # make list of file names to iterate through
PAIRED=$(ls *_paired_output.bam | sed -n ${SLURM_ARRAY_TASK_ID}p) # make list of file names to iterate through

# e.g. assigns "20_242" from 20_242_S94_L001_R2_001.fastq.gz as SAMPLE_NAME
SAMPLE_NAME=$(echo $PAIRED |cut  -d "_" -f 1,2 )

## merge bams with samtools merge
echo " samtools merge -r ${SAMPLE_NAME}_merged.bam ${PAIRED} ${F_UNPAIRED} ${R_UNPAIRED} "
samtools merge -r ${SAMPLE_NAME}_merged.bam ${PAIRED} ${F_UNPAIRED} ${R_UNPAIRED}