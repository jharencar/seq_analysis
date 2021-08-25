#!/bin/bash
#SBATCH --partition 128x24 # this means each node (there are 19 nodes in this partition) has 128 GB RAM and 24 cores/cpus 
#SBATCH --job-name=full_AVH_PCAngsd_1# Job name
#SBATCH --time=72:00:00 
#SBATCH --output=full_AVH_PCAngsd_1_output.txt
#SBATCH --mail-type=END, FAIL              # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jharenca@ucsc.edu  # Where to send mail
#SBATCH --nodes=1
#SBATCH --chdir=/hb/scratch/jharenca/vill_alle_plate1/newdata/whole_plate_mapping/ANGSD/PCAngsd_out 

## load ANGSD and samtools
module load angsd/gnu-930 samtools/samtools-1.10

## set directories
IN_DIR=/hb/scratch/jharenca/pop_gen/combinedP1P2/ANGSD/angsd_in
OUT_DIR=/hb/scratch/jharenca/pop_gen/combinedP1P2/ANGSD/PCAngsd_out

# call pcangsd
# options (and defaults): http://www.popgen.dk/software/index.php/PCAngsd
# default params used in these runs 
#(-iter 0, means without estimating individual allele freqs. this seems preferable given low individual coverage, 
# but the plots more clearly demonstrate the pattern when we do the estimate. See PCAngsd_angsd1.Rmd for comparison of plots)

#run on AVH only
echo "python /hb/home/jharenca/Software/pcangsd/pcangsd.py -beagle $IN_DIR/full_AVH.genolike.beagle.gz -o $OUT_DIR/full_AVH_1_PCAngsd"
python /hb/home/jharenca/Software/pcangsd/pcangsd.py -beagle $IN_DIR/full_AVH.genolike.beagle.gz -o $OUT_DIR/full_AVH_1_PCAngsd



