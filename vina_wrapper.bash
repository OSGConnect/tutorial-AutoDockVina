#!/bin/bash

module load autodock 
vina --config receptor_config.txt --ligand ligand.pdbqt --out receptor-ligand_output.pdbqt --log receptor-ligand_ligand.log
