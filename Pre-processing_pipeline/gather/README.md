# .fasta.gz and .fastqc seperator and aggregator

The script seq_gather.py is a python script (written for python3)

After cloning the repository please make sure the file is executable, using `chmod +x seq_gather.py` if necessary.

You will need the python packages "os", "glob", and "fnmatch" to run. 

The script seq_gather.py looks through all folders in the current directory and lists all files found within those subdirectories. It then collects all fastqc files into a folder it creates called seq_fastqc and all .fasta files into a folder called seq_data.

