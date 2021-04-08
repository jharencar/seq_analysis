#!/bin/bash
#SBATCH --job-name=dedup # Job name
#SBATCH --time=1-12:00:00
#SBATCH --output=dedup_output.txt
#SBATCH --mail-type=ALL              # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jharenca@ucsc.edu  # Where to send mail
#SBATCH --nodes=1                    # Use one node
#SBATCH --ntasks-per-node=20             
#SBATCH --cpus-per-task=1            # Number of CPU cores per task
#SBATCH --mem=20G                    # Memory per node
#SBATCH -p 128x24   # Partition name

##loading python3 and bbtools
module load python-3.7.6GPU bbtools/bbmap-38.79

## change into the directory where sequence files reside
cd /hb/scratch/jharenca/vill_alle_plate1/newdata/whole_plate_mapping/fastq_files

## call the code to run
python3 /hb/scratch/jharenca/vill_alle_plate1/newdata/whole_plate_mapping/dedup.py
