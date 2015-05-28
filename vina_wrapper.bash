#!/bin/bash

module load autodock 
vina --config receptor_config.txt --ligand ligand.pdbqt --out receptor-ligand.pdbqt --log receptor-ligand.log
