#!/bin/bash

# Make a directory for results
mkdir results

# Run vina on multiple ligands
for LIGAND in *ligand.pdbqt
do 
./vina --config receptor_config.txt \
     --ligand ${LIGAND} --out results/receptor-${LIGAND}
done
