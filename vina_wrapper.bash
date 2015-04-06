#!/bin/bash

module load autodock 
vina --config 2gut_config.txt --ligand ligand.pdbqt --out 2gut_ligand_output.pdbqt --log 2gut_ligand.log
