---
ospool:
    path: software_examples/drug_discovery/tutorial-AutoDockVina/README.md
---

# Running a Molecule Docking Job with AutoDock Vina

[AutoDock Vina](http://vina.scripps.edu/) is a molecular docking program useful for computer aided drug design.  In this tutorial, we will learn how to run AutoDock Vina on OSG.  

## Tutorial Files 

It is easiest to start with the `tutorial` command. Type:

	$ tutorial AutoDockVina

This will create a directory `tutorial-AutodockVina`. Change into the directory and look at the available files: 

	$ cd tutorial-AutoDockVina
	$ ls

You should see the following: 

	receptor_config.txt   # Configuration file (input)
	data/
		receptor.pdbqt    # Receptor coordinates and atomic charges (input)
		ligand.pdbqt      # Ligand coordinates and atomic charges (input)
	vina_job.submit       # Job submission file
	vina_wrapper.bash     # Execution script

We need to download the AutoDock program separately into the this directory as well. Go 
to the [AutoDock Vina website](http://vina.scripps.edu/) and click on the Download link at the top of the page. Download the Linux version of the program; you can do this directly to the current directory by using the `wget` command and the download link. If you use the 
`-O` option shown below, it will rename the tar file to match what is used in the rest of the guide. 

	$ wget http://vina.scripps.edu/download/autodock_vina_1_1_2_linux_x86.tgz -O autodock_vina.tar.gz

## Files Need to Submit the Job

The file `vina_job.submit` is the job submission file and contains the description of the job in HTCondor language. Specifically, it includes an "executable" (the script HTCondor will use in the job to run vina), a list of the files needed to run the job (shown in "transfer_input_files"), and indications of where to write logging information and what resources and requirements the job needs. 

**Change needed:** If your download software tar.gz file has a different name, change the name in the `transfer_input_files` line below. 

	executable = vina_wrapper.bash

	transfer_input_files    = data/, receptor_config.txt, autodock_vina.tar.gz
	should_transfer_files   = Yes
	when_to_transfer_output = ON_EXIT

	output        = job.$(Cluster).$(Process).out
	error         = job.$(Cluster).$(Process).error
	log           = job.$(Cluster).$(Process).log

	requirements   = (OSGVO_OS_STRING == "RHEL 7")
	request_cpus   = 1
	request_memory = 512MB
	request_disk   = 512MB

	queue 1


Next we see the execution wrapper  `vina_wrapper.bash`. The execution wrapper and its inside content are executed on a worker node out in the Open Science Pool. The first two commands will unzip the file containing the AutoDock Vina program and make it accessible on the command line; we can then run a typical vina command. 

**Change needed:** If your download tar.gz file has a different name, change it in the 
script below, in the `tar` command. You will also need to change the name of the `AUTODOCK_FOLDER` to match whatever folder appears when you un-tar the downloaded tar.gz file. 

	#!/bin/bash

	# set TMPDIR variable
	export TMPDIR=$_CONDOR_SCRATCH_DIR

	# Unzip autodock vina software
	tar -xzf autodock_vina.tar.gz
	export PATH=$PWD/AUTODOCK_FOLDER/bin:$PATH

	# Run vina
	vina --config receptor_config.txt \
		 --ligand ligand.pdbqt --out receptor-ligand.pdbqt \
		 --log receptor-ligand.log

	
## Running the simulation
		
We submit the job using `condor_submit` command as follows

	$ condor_submit vina_job.submit
	
Now you have submitted the AutoDock Vina job on the OSG.  The present job should be finished quickly (less than 10 mins). You can check the status of the submitted job by using `condor_q` command as follows:

	$ condor_q username

After job completion, you will see the output files `receptor-ligand_output.pdbqt` and `receptor-ligand.log` in your work directory.

## Next Steps

After running this example, you may want to scale up to testing multiple molecules or ligands. Some good starting points for this include: 

- Decide how many docking runs you want to try per job. If one molecule can be tested in a few seconds, you can probably run a few hundred in a job that runs in about an hour. 
- How should you divide up the input data in this case? Do you need individual input files for each molecule, or can you use one to share? Should the molecule files all get copied to every job or just the jobs where they're needed? You can separate groups of files by putting them in separate directories or tar.gz files to help with this. 
- Look at [this guide](https://portal.osg-htc.org/documentation/software_examples_for_osg/python/tutorial-ScalingUp-Python/) to see different ways that you can use HTCondor to submit multiple jobs at once. 

If you want to use a different (or additional) docking programs, you can include them in the same job by downloading and including those software files in your job submission. 

## Getting Help

For assistance or questions, please email the OSG User Support team  at [support@opensciencegrid.org](mailto:support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).
