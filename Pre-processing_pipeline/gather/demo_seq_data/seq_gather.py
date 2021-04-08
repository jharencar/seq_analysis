import os
from glob import iglob 
import fnmatch
import sys

print ("sorting and aggregating sequence and fastqc files into seq_data and seq_fastqc folders")

try:
	# making directories for files
	os.makedirs("seq_data")
except:
	print("seq_data directory already exists")
	sys.exit(0)
	
try:
	os.makedirs("seq_fastqc")
except:
	print("seq_fastqc directory already exists")
	sys.exit(0)

# This will return absolute paths to all files in all folders in the current folder
file_list = [f for f in iglob('**/*', recursive=True) if os.path.isfile(f)]

for f in file_list: # iterating over all the files in the file_list made above
	if fnmatch.fnmatch(f,"*.fastq.gz")==True:# if it is a .fastq.gz, put it in seq_data folder
		c = "cp " + f + " ./seq_data" # creating a variable to plug in each file name when it meets the criteria of the if statement 
		os.system(c)
	if fnmatch.fnmatch(f,"*_fastqc.html")==True:# if it is a _fastqc.html, put it in seq_fastqc folder
		c = "cp " + f + " ./seq_fastqc"
		os.system(c)
	
		
	