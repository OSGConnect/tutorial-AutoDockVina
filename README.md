Table of Contents
=================

  * [Autodock Vina Tutorial](#autodock-vina-tutorial)
      * [Overview](#overview)
      * [Autodock Vina tutorial files](#autodock-vina-tutorial-files)
      * [Job execution and submission files](#job-execution-and-submission-files)
      * [Running the simulation](#running-the-simulation)
      * [Help](#help)


# Autodock Vina Tutorial

## Overview
Autodock Vina is a molecular docking program useful for computer aided drug design.  In this tutorial, we will learn how to run Autodock Vina on open science grid (OSG).  We have a separate tutorial for screening a library of several ligands.

## Autodock Vina tutorial files

It is easy to start with the "tutorial" command. In the command prompt, type
```
$ tutorial VinaAutodock ### Creates "tutorial-VinaAutodock" directory with input, job submission and execution script files
```
 
This will create a directory “tutorial-VinaAutodock". Inside the directory, you will see the following files
```
receptor_config.txt   # Configuration file (input)
receptor.pdbqt        # Receptor coordinates and atomic charges (input)
ligand.pdbqt          # Ligand coordinates and atomic charges (input)
vina_job.submit       # Job submission file
vina_wrapper.bash     # Execution script
```
 We discuss the details of  "vina_job.submit" and "vian_wrapper.bash" files. To see how to prepare the input files, receptor_config.txt,  receptor.pdbqt and ligand.pdbqt, check the autodock website at Scripps Research Institute. 

##Job execution and submission files
The file “vina_job.submit” is the job submission file and contains the description of the job in HTCondor language. 
```
Universe = vanilla             # The Universe defines an execution environment for Condor 
Executable = vina_wrapper.bash # Executable is either a binary or a shell wrapper script
 
transfer_input_files = receptor_config.txt, receptor.pdbqt, ligand.pdbqt  # Input files transfred to the worker machine
should_transfer_output_files=Yes    # Transfers all the output files
when_to_transfer_output = ON_EXIT   # File transfers are performed on exit 
output        = job.out             # Standard output from your job goes in this file
error         = job.error           # Standard error from your job goes in this file
log           = job.log             # Status of your job is logged in this file
requirements = (HAS_CVMFS_oasis_opensciencegrid_org =?= TRUE) # Check the availability of OASIS on remote worker machine
Queue 1        # The above job descriptions are send to the queue
```
The job description is expressed in key-value(s) pair.  For example, the key is "Universe" and the value is "vanilla". The key "transfer_input_files" can have more than one value. 
 
 Next we see the execution wrapper  “vina_wrapper.bash”. The execution wrapper and its inside content are executed in the remote worker machine.
 ```
#!/bin/bash           ### Shell interpreter.
module load autodock  # Sets up the environment (such as path of the binary, libraries ..etc) to run autodock vina.
vina --config receptor_config.txt --ligand ligand.pdbqt --out receptor-ligand_output.pdbqt --log receptor-ligand.log   # Execution of vina with input and output files as arguments.
```
## Running the simulation
We submit the job using "condor_submit" command as follows
```
$ condor_submit vina_job.submit # Submit the condor job script "vina_job.submit"
```

Now you have submitted the autodock vina job on the open science grid. The present job should be finished quickly (less than 10 mins). You can check the status of the submitted job by using  "condor_q" command as follows
```
$ condor_q username # The status of the job is printed on the screen. Here, username is your login name.
```
After job completion, you will see the output files  receptor-ligand_output.pdbqt and receptor-ligand.log in your work directory.

## Help 
For further assistance or questions, please email ***connect-support@opensciencegrid.org***
