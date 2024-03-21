---
ospool:
    path: software_examples/drug_discovery/tutorial-AutoDockVina/README.md
---

# Running a Molecule Docking Job with AutoDock Vina

[AutoDock Vina](http://vina.scripps.edu/) is a molecular docking program useful for computer aided drug design.  In this tutorial, we will learn how to run AutoDock Vina on the OSPool.  

## Tutorial Files 

It is easiest to start with the `git clone` command to download the materials for this tutorial. Type:

	$ git clone https://github.com/OSGConnect/tutorial-AutoDockVina

This will create a directory `tutorial-AutoDockVina`. Change into the directory and look at the available files: 

	$ cd tutorial-AutoDockVina
	$ ls
	$ ls data/

You should see the following: 

	data/
 	    receptor_config.txt  # Configuration file (input)
		receptor.pdbqt       # Receptor coordinates and atomic charges (input)
		ligand.pdbqt         # Ligand coordinates and atomic charges (input)
	logs/					 # Empty folder for job log files
	vina_job.submit          # Job submission file
	vina_run.sh     	     # Execution script

We need to download the AutoDock program separately into the this directory as well. Go 
to the [AutoDock Vina website](http://vina.scripps.edu/) and click on the Download link at the top of the page. Download the Linux version of the program; you can do this directly to the current directory by using the `wget` command and the download link. If you use the 
`-O` option shown below, it will rename the tar file to match what is used in the rest of the guide. 

	$ wget http://vina.scripps.edu/download/autodock_vina_1_1_2_linux_x86.tgz -O autodock_vina.tar.gz

## Files Need to Submit the Job

The file `vina_job.submit` is the job submission file and contains the description of the job in HTCondor language. Specifically, it includes an "executable" (the script HTCondor will use in the job to run vina), a list of the files needed to run the job (shown in "transfer_input_files"), the name of a results directory to transfer back from the completed job, and indications of where to write logging information and what resources and requirements the job needs. 

**Change needed:** If your download software tar.gz file has a different name, change the name in the `transfer_input_files` line below. Also change the name of the Vina directory. 
This can be found by running `tar -tf autodock_vina.tar.gz`

	VINA_DIR = autodock_vina_1_1_2
	
	executable = vina_run.sh
	arguments = $(VINA_DIR)
	
	transfer_input_files    = data/, autodock_vina.tar.gz
	transfer_output_files   = results
	should_transfer_files   = Yes
	when_to_transfer_output = ON_EXIT
	
	output        = logs/job.$(Cluster).$(Process).out
	error         = logs/job.$(Cluster).$(Process).error
	log           = logs/job.$(Cluster).$(Process).log
	
	request_cpus   = 1
	request_memory = 512MB
	request_disk   = 512MB
	
	queue 1

Next we see the execution script `vina_run.sh`. The execution script and its commands are executed on a worker node out in the Open Science Pool. The first two commands will unzip the file containing the AutoDock Vina program and make it accessible on the command line. 
We will also make a folder inside the job for the results. Then we can then run a typical vina command. 

**Change needed:** If your download tar.gz file has a different name, change it in the 
script below, in the `tar` command. 

	#!/bin/bash
	
	VINA_DIR=$1
	
	# Unzip autodock vina software into a folder called autodock
	tar -xzf autodock_vina.tar.gz
	export PATH=$PWD/${VINA_DIR}/bin:$PATH
	
	# Make a directory for results
	mkdir results
	
	# Run vina
	vina --config receptor_config.txt \
		 --ligand ligand.pdbqt --out results/receptor-ligand.pdbqt \
		 --log results/receptor-ligand.log
	
## Submit the Docking Job
		
We submit the job using `condor_submit` command as follows

	$ condor_submit vina_job.submit
	
Now you have submitted the AutoDock Vina job on the OSPool.  The present job should be finished quickly (less than 10 mins). You can check the status of the submitted job by using  the`condor_q` command as follows:

	$ condor_q

After job completion, you will see the output files `receptor-ligand.pdbqt` and `receptor-ligand.log` in the "results" directory. 

## Next Steps

After running this example, you may want to scale up to testing multiple molecules or ligands. 

### What to Consider

- Decide how many docking runs you want to try per job. If one molecule can be tested in a few seconds, you can probably run a few hundred in a job that runs in about an hour. 
- How should you divide up the input data in this case? Do you need individual input files for each molecule, or can you use one to share? Should the molecule files all get copied to every job or just the jobs where they're needed? You can separate groups of files by putting them in separate directories or tar.gz files to help with this. 
- Look at [this guide](https://portal.osg-htc.org/documentation/htc_workloads/submitting_workloads/submit-multiple-jobs/) to see different ways that you can use HTCondor to submit multiple jobs at once. 

If you want to use a different (or additional) docking programs, you can include them in the same job by downloading and including those software files in your job submission. 

### Example of Multiple Runs

Included in this directory is *one* approach to analyzing multiple ligands, by 
submitting multiple jobs. For the given files we are assuming that there are multiple 
directories with input files we want to run (`run01`, `run02`, `run03`, etc.) and each 
job will process all of the ligands in one of these "run" folders. 

In the script, `vina_multi.sh`, we had added a for loop in order to process all 
the ligands that were included with the job: 

	# Run vina on multiple ligands        
	for LIGAND in *ligand.pdbqt
	do 
	vina --config receptor_config.txt \
		 --ligand ${LIGAND} --out results/receptor-${LIGAND} \
		 --log results/receptor-${LIGAND}.log
	done

This assumes that all of the ligands have a naming scheme that we can 
match using a wildcard (the `*` symbol). 

And in the submit file, we have replaced the single input directory `data` with 
a variable `inputdir`, representing one of the `run` directories.  The value 
of that variable is set via the queue statement 
at the end of the submit file: 

	transfer_input_files    = $(inputdir)/, autodock_vina.tar.gz
	## ...other submit file details
	
	queue inputdir matching run*


## Getting Help

For assistance or questions, please email the OSG User Support team at [support@osg-htc.org](mailto:support@osg-htc.org) or visit the [help desk and community forums](https://portal.osg-htc.org/documentation/).
