[title]: - "AutoDock Vina"
[TOC]
 
## Overview
[AutoDock Vina](http://vina.scripps.edu/) is a molecular docking program useful for computer aided drug design.  In this tutorial, we will learn how to run AutoDock Vina on OSG.  We have a separate tutorial for screening a library of several ligands.

## Tutorial files

It is easiest to start with the `tutorial` command. Type:

	$ tutorial AutodockVina ### Creates "tutorial-AutodockVina" directory with input, job submission and execution script files

This will create a directory `tutorial-AutodockVina`. Inside the directory, you will see the following files

	receptor_config.txt   # Configuration file (input)
	receptor.pdbqt        # Receptor coordinates and atomic charges (input)
	ligand.pdbqt          # Ligand coordinates and atomic charges (input)
	vina_job.submit       # Job submission file
	vina_wrapper.bash     # Execution script

We discuss the details of  `vina_job.submit` and `vian_wrapper.bash` files. To see how to prepare the input files, `receptor_config.txt`,  `receptor.pdbqt` and `ligand.pdbqt`, check the AutoDock website.

## Job execution and submission files

The file `vina_job.submit` is the job submission file and contains the description of the job in HTCondor language. 

	Universe = vanilla             # The Universe defines an execution environment for Condor 
	Executable = vina_wrapper.bash # Executable is either a binary or a shell wrapper script
	 
	transfer_input_files = receptor_config.txt, receptor.pdbqt, ligand.pdbqt  # Input files transfred to the worker machine
	should_transfer_output_files = Yes    # Transfers all the output files
	when_to_transfer_output = ON_EXIT   # File transfers are performed on exit 
	output        = job.out.$(Process)             # Standard output from your job goes in this file
	error         = job.error.$(Process)           # Standard error from your job goes in this file
	log           = job.log.$(Process)             # Status of your job is logged in this file
	requirements = (HAS_CVMFS_oasis_opensciencegrid_org =?= TRUE) # Check the availability of OASIS on remote worker machine
	Queue 1        # The above job descriptions are send to the queue


Next we see the execution wrapper  `vina_wrapper.bash`. The execution wrapper and its inside content are executed in the remote worker machine.


	#!/bin/bash           ### Shell interpreter.
	module load autodock  # Sets up the environment (such as path of the binary, libraries ..etc) to run autodock vina.
	vina --config receptor_config.txt --ligand ligand.pdbqt --out receptor-ligand_output.pdbqt --log receptor-ligand.log   # Execution of vina with input and output files as arguments.
	
## Running the simulation
		
We submit the job using `condor_submit` command as follows

	$ condor_submit vina_job.submit # Submit the condor job script "vina_job.submit"
	
Now you have submitted the AutoDock Vina job on the OSG.  The present job should be finished quickly (less than 10 mins). You can check the status of the submitted job by using `condor_q` command as follows:

	$ condor_q username # The status of the job is printed on the screen. Here, username is your login name.

After job completion, you will see the output files `receptor-ligand_output.pdbqt` and `receptor-ligand.log` in your work directory.
		
## Getting Help
For assistance or questions, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).
