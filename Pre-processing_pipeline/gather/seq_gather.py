
# Python 3 code for extracting fastas into one file and fastqc htmls into another from the directory with an separate folder for each sample. 
# Must be run in directory containing all the individual sample folders (cd into the directory first or in the .slurm code if running with sbatch)
# Created by: Julia Harencar, Sept. 2020
###################################################################################

import os
from glob import iglob 
import fnmatch

print ("sorting and aggregating sequence and fastqc files into seq_data and seq_fastqc folders")

# making directories for files
os.makedirs("seq_data")
os.makedirs("seq_fastqc")

# This will return absolute paths to all files in all folders in the current folder
file_list = [f for f in iglob('**/*', recursive=True) if os.path.isfile(f)]

for f in file_list: # iterating over all the files in the file_list made above
	if fnmatch.fnmatch(f,"*.fastq.gz")==True:# if it is a .fastq.gz, put it in seq_data folder
		c = "cp " + f + " ./seq_data" #creating a variable to plug in each file name when it meets the criteria of the if statement 
		os.system(c)
	if fnmatch.fnmatch(f,"*_fastqc.html")==True:# if it is a _fastqc.html, put it in seq_fastqc folder
		c = "cp " + f + " ./seq_fastqc"
		os.system(c)
print("done └(^o^ )┘")
		
	