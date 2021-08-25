#!/bin/bash
#SBATCH --job-name=trimmomatic # Job name
#SBATCH --time=3-12:00:00
#SBATCH --output=trimmomatic_output.txt
#SBATCH --mail-type=END,FAIL              # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jharenca@ucsc.edu  # Where to send mail
#SBATCH -p 128x24   # Partition name
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --array=[1-96]%3 # []%3 limits it so only 3 run in parallel at once
#submit with SBATCH array, submit as normal or to specify certain array numbers: sbatch --array=x-y job_script.sbatch

#### Trimmomatic trimming and cleaning code for Tn5 LCWG illumina HiSeq data ####
#### Created by Julia Gardner Harencar
#### Winter 2021

##ARRAY NOTES: Tasks can mean multiple things, depending on context.
##(more info on arrays: https://support.ceci-hpc.be/doc/_contents/SubmittingJobs/SlurmFAQ.html)
###Here, we array over 3 nodes, one operation per node because there is a high memory need and one operation takes all the memory on the node
# So, even if we set it up to put multiple operations on a node it won't bc it cannot fit them 
# to actually run 2 operations on one node, would have to set --mem to 64 bc that is half of the available memory on the node(keep nodes=1, set ntasks=2, cpus-per-task=12 )

# load trimmomatic
module load trimmomatic

# move into directory with files and code
cd /hb/home/jharenca/pop_gen/raw_data/plate1

## script to gently quality trim and clip adapters with trimmomatic
## Created by Julia Harencar, Jan 13, 2021

# variable setting
# Set up array variables so that the same SLURM_ARRAY_TASK_ID references both input files for a given individual (F and R reads)
R1=$(ls *_R1_001.fq.gz| sed -n ${SLURM_ARRAY_TASK_ID}p)
R2=$(ls *_R2_001.fq.gz| sed -n ${SLURM_ARRAY_TASK_ID}p)

# e.g. assigns "18.080_LASI" from SE5869_18.080_LASI_S35_clumped1.fq.gz as SAMPLE_NAME
SAMPLE_NAME=$(echo $R1 |cut  -d "_" -f 2,3 )

## Trimmomatic ##

# PE indicates paired end mode 
# provided NexteraPE-PE.fa adapter file is correct for Tn5 transposase sequences, I had to load this file into the local directory with my reads for no good reason...(illumina adapters already removed, it seems)
# ILLUMINACLIP:NexteraPE-PE.fa:[seed mismatches]:[palindrome clip threshold]:[simple clip threshold]:[min adapter lenght]:keepBothReads LEADING:3 TRAILING:3 MINLEN:21
# Seed mismatches: max number of mismatches allowed for full alignment to adapter reference. If more than that many mismatches, will not do full alignment score. I kept this small as i am trimming conservatively. 
# Matching threshold with an odd translation, but 30 or above even is good for palindromic matches (when there are F and R reads)
# simple is threshold for any non-paired reads and is lower because of the lost palindrome power (read here for more info: http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf)
# min adapter length is exaclty what it sounds like, defalut is 8, meaning that is the minimum size of an adapter sequence to be removed, but should be lower becasue palindrome mode has very low false positive rate.
# Keeps paired reads even if containing redundant info (I think I need this for mapping because I don't think bwa can handle a combination of paired and unpaired reads)
# Leading: remove low quality bases from the beginning - as long as the base has value below threshold, will be removed, and the next base checked. 
# Trailing: same thing on end of read. 
# Minlen: drop read if it is below a specific length 
# 48 threads becasue 24 cpus per node and each can handle 2 threads. 

# first just printing the line that will run 
echo "java -jar /hb/software/apps/trimmomatic/gnu-0.39/trimmomatic-0.39.jar PE -threads 48 ${R1} ${R2} \
	${SAMPLE_NAME}_F_paired.fq.gz ${SAMPLE_NAME}_F_unpaired.fq.gz \
	${SAMPLE_NAME}_R_paired.fq.gz ${SAMPLE_NAME}_R_unpaired.fq.gz \
	ILLUMINACLIP:NexteraPE-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:100"

# actually running the code
java -jar /hb/software/apps/trimmomatic/gnu-0.39/trimmomatic-0.39.jar PE -threads 48 ${R1} ${R2} \
	${SAMPLE_NAME}_F_paired.fq.gz ${SAMPLE_NAME}_F_unpaired.fq.gz \
	${SAMPLE_NAME}_R_paired.fq.gz ${SAMPLE_NAME}_R_unpaired.fq.gz \
	ILLUMINACLIP:NexteraPE-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:100

echo "done!  └(^o^ )┘"
